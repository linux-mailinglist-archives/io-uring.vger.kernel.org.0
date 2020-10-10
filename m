Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6F6289FE6
	for <lists+io-uring@lfdr.de>; Sat, 10 Oct 2020 12:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgJJKGQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 06:06:16 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:40356 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgJJJv1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 05:51:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UBZ6MGv_1602322752;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UBZ6MGv_1602322752)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 10 Oct 2020 17:39:12 +0800
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
From:   Hao_Xu <haoxu@linux.alibaba.com>
Subject: [Question] testing results of support async buffered reads feature
Message-ID: <f810df0d-e920-3183-f0eb-dbb17c60f157@linux.alibaba.com>
Date:   Sat, 10 Oct 2020 17:39:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
I've done some testing for io_uring async buffered reads with fio. But I 
found something strange to me.
- when readahead is exactly turned off, the async buffered reads feature 
appears to be worse than the io-wq method in terms of IOPS.
- when readahead is on, async buffered reads works better but the 
optimization rate seems to be related with the size of readahead.
I'm wondering why.

my environment is:
	server: physical server
	kernel: mainline 5.9.0-rc8+ latest commit 6f2f486d57c4d562cdf4
	fs: ext4
	device: nvme
	fio: 3.20
	
I did the tests by setting and commenting the code:
	filp->f_mode |= FMODE_BUF_RASYNC;
in fs/ext4/file.c ext4_file_open()

the IOPS in different condition is below:

when blockdev setra 0 /mnt/nvme0n1
QD/Test		FMODE_BUF_RASYNC set	FMODE_BUF_RASYNC not set
1		12.9k			11.0k
2		32.4k			29.7k
4		65.8k			62.1k
8		123k			116k
16		211k			208k
32		235k			296k
64		241k			328k
128		229k			312k

the async buffered reads feature has a smaller IOPS.

when blockdev setra 64 /mnt/nvme0n1
QD/Test		FMODE_BUF_RASYNC set	FMODE_BUF_RASYNC not set
1		11.4k			12.2k
2		23.8k			30.0k
4		52.7k			61.7k
8		122k			114k
16		208k			181k
32		237k			199k
64		260k			185k
128		231k			201k

for QD=64	(260-185)/185 = 40.5%

when blockdev setra 128 /mnt/nvme0n1
QD/Test		FMODE_BUF_RASYNC set	FMODE_BUF_RASYNC not set
1		11.4k			10.8k
2		23.9k			22.7k
4		53.1k			46.5k
8		122k			106k
16		204k			182k
32		212k			200k
64		242k			202k
128		229k			188k

for QD=64	(242-202)/202 = 20.0%

when blockdev setra 256 /mnt/nvme0n1
QD/Test		FMODE_BUF_RASYNC set	FMODE_BUF_RASYNC not set
1		11.5k			12.2k
2		23.8k			29.7k
4		52.9k			61.9k
8		121k			117k
16		207k			186k
32		229k			204k
64		230k			211k
128		240k			203k

for QD=64	(230-211)/211 = 9.0%

the arguments of fio I use are:
fio_test.sh:
blockdev --setra $2 /dev/nvme0n1
fio -filename=/mnt/nvme0n1/fio_read_test.txt \
     -buffered=1 \
     -iodepth $1 \
     -rw=randread \
     -ioengine=io_uring \
     -randseed=89 \
     -runtime=10s \
     -norandommap \
     -direct=0 \
     -bs=4k \
     -size=4G \
     -name=rand_read_4k
