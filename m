Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75FF2EFBC3
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 00:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbhAHXkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 18:40:39 -0500
Received: from a4-3.smtp-out.eu-west-1.amazonses.com ([54.240.4.3]:49173 "EHLO
        a4-3.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbhAHXkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 18:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610149162;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=bvxF/o73+i7HpZaaBZEIl7UDaXHBI+E0oPJd3hI3U8E=;
        b=aqKPTZwReaZTmh703t8B+gsPvj3ZQD5fqBufCNvf9U+qCu/Dlc3gtSseJcPsC1os
        mLZpMrMIyEwjiPTpRygCZGbke/bbCTmuKhoZuDfAbr/09V4zRpqGjKPA6alJ4NDfqjy
        SpmTgenPK4UhzJ7w5j8Uqg387hOhStHYWDnQvxGY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610149162;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=bvxF/o73+i7HpZaaBZEIl7UDaXHBI+E0oPJd3hI3U8E=;
        b=Gp+Y+1WCGv39OGUGgqeYKhrV0E8RP0B45ix0aM7o0K/D/SH+GM51TGDjw+c5on9b
        jxfPZXeKmfQI3hLJhPWjvrhCCN7osgcYoVM2uso9darg5IwVOU30kCyTSyLjtNbC/Hk
        3YPRobQIZZ04s5CHpMkVJ546D0Ilkzxqcz2dXilE=
To:     io-uring@vger.kernel.org
From:   Martin Raiber <martin@urbackup.org>
Subject: Fixed buffer have out-dated content
Message-ID: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
Date:   Fri, 8 Jan 2021 23:39:22 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2021.01.08-54.240.4.3
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I have a gnarly issue with io_uring and fixed buffers (fixed 
read/write). It seems the contents of those buffers contain old data in 
some rare cases under memory pressure after a read/during a write.

Specifically I use io_uring with fuse and to confirm this is not some 
user space issue let fuse print the unique id it adds to each request. 
Fuse adds this request data to a pipe, and when the pipe buffer is later 
copied to the io_uring fixed buffer it has the id of a fuse request 
returned earlier using the same buffer while returning the size of the 
new request. Or I set the unique id in the buffer, write it to fuse (via 
writing to a pipe, then splicing) and then fuse returns with e.g. 
ENOENT, because the unique id is not correct because in kernel it reads 
the id of the previous, already completed, request using this buffer.

To make reproducing this faster running memtester (which mlocks a 
configurable amount of memory) with a large amount of user memory every 
30s helps. So it has something to do with swapping? It seems to not 
occur if no swap space is active. Problem occurs without warning when 
the kernel is build with KASAN and slab debugging.

If I don't use the _FIXED opcodes (which is easy to do), the problem 
does not occur.

Problem occurs with 5.9.16 and 5.10.5.

Regards,
Martin Raiber

