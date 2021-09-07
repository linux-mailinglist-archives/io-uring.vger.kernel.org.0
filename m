Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BE402BD9
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 17:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbhIGPda (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 11:33:30 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50999 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344935AbhIGPda (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 11:33:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Unc-CFO_1631028741;
Received: from 30.30.107.109(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Unc-CFO_1631028741)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Sep 2021 23:32:22 +0800
Subject: Re: [PATCH] io_uring: check file_slot early when accept use fix_file
 mode
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907151653.18501-1-haoxu@linux.alibaba.com>
 <3ca81c51-87fb-2f1d-f3f7-92abafdd5cca@kernel.dk>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <1cff2f6f-d979-f667-180f-b09d548aa640@linux.alibaba.com>
Date:   Tue, 7 Sep 2021 23:32:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3ca81c51-87fb-2f1d-f3f7-92abafdd5cca@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/7 下午11:24, Jens Axboe 写道:
> On 9/7/21 9:16 AM, Hao Xu wrote:
>> check file_slot early in io_accept_prep() to avoid wasted effort in
>> failure cases.
> 
> It's generally better to just let the failure cases deal with it instead
> of having checks in multiple places. This is a failure path, so we don't
> care about making it fail early. Optimizations should be for the hot path,
> which is not a malformed sqe.
I have a question here: if we do do_accept() and but fail in
io_install_fixed_file(), do we lose the conn_fd return by do_accept()
forever?
> 

