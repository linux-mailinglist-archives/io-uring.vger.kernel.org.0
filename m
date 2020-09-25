Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97222793AC
	for <lists+io-uring@lfdr.de>; Fri, 25 Sep 2020 23:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIYVjv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 17:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgIYVju (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 17:39:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7F6C0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:39:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so3664142pgm.11
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RCkGtqVJvePVImWfKnIc8fcGEbvndjjAsQBE6tRVl4I=;
        b=0HwIsAKIBjoP+i0yIrg7vA9m5O354pvf7Lp0m7nTqngRYrTEmuml9P8tU4nz4x7RYM
         aWXTQMpBHQyEeXPtdyYCAUVV8wFPtGrpwm5Vjjrid4polRo13RoAMRa3VzNgquoi/FWy
         wIS5bizmYNhDsDUhQKw35a6+Vj1XHVsuDZvHKxD6HJs2jcFSk0NhFv3YW/kMvKdPWjNF
         zVPbVX5wCPNc7hvS+QvTE4wiuIlONOkyRabeGpMf1gBDu6mv7moxeVpx+PxB5MKG4IPy
         Csg4QtNZh+xpM8T5A2Cq/+ZtPArirbsgQ0ipKkSM+77mOB6pRxxSvmDIEASCfic4PgmC
         reZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RCkGtqVJvePVImWfKnIc8fcGEbvndjjAsQBE6tRVl4I=;
        b=mIGGqgMkfzbMwj1+ohKq28HoL84Jdok7ivjuLsOE32J2/Zzg7W1eMpxLtNvyejmlGE
         Hky0FVoO4GInho/zHUbdyG+aTQMoWxMYaEbXCOBrdkffYT+MtsDG+LKozL+VvpZKh1Di
         6ywy2Ep6/uEWV5/btdiGocoVk68etMd3asEOqA6U3+ietdJ/OpcjKM5/VxixwyUkNybH
         BIhHY2ydcKwGaF4IyYUaAVEcIAuSPvVSOzTZp8wVR7JANqZWP4Qc7KzTsLrGF0ay7386
         9wIhduasHCionYKf1WDMo3VLJ08QmDGOA7BEl5u/pf2wxnrOMihWyM2HL1NrNxP7wntG
         WIjw==
X-Gm-Message-State: AOAM530hVwuKTkTJ/DVzg4jHhJrmqBIm0snXVEyvXsY+8Lf+2vh7rC3j
        bpckNpMsXEdGBYgpN+AbMbsdK1+m0g7liKkD
X-Google-Smtp-Source: ABdhPJyWSdspWU1/wHom41G1uF+0+itTZEB/lQKDepklLwejhm1Gb0YlbgnScpG6fWp/K1hGf5CfKQ==
X-Received: by 2002:aa7:9491:0:b029:142:2501:34dd with SMTP id z17-20020aa794910000b0290142250134ddmr1139189pfk.54.1601069989863;
        Fri, 25 Sep 2020 14:39:49 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 137sm3692893pfu.149.2020.09.25.14.39.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:39:49 -0700 (PDT)
Subject: Re: [Question] about async buffered reads feature
From:   Jens Axboe <axboe@kernel.dk>
To:     Hao_Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <a1bd6dfd-c911-dfe8-ec7f-4fac5ac8c73e@linux.alibaba.com>
 <09ea598d-6721-4e67-df4a-2bbb8ada24d9@kernel.dk>
Message-ID: <f890b197-94f8-29c0-39e6-6ed28b65c12b@kernel.dk>
Date:   Fri, 25 Sep 2020 15:39:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <09ea598d-6721-4e67-df4a-2bbb8ada24d9@kernel.dk>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/25/20 3:23 PM, Jens Axboe wrote:
> On 9/25/20 3:18 AM, Hao_Xu wrote:
>> Hi Jens,
>> I'm doing tests about this feature: [PATCHSET RFC 0/11] Add support for 
>> async buffered reads
>> But currently with fio testing, I found the code doesn't go to the 
>> essential places in the function generic_file_buffered_read:
>>
>>            if (iocb->ki_flags & IOCB_WAITQ) {
>>                    if (written) {
>>                            put_page(page);
>>                            goto out;
>>                    }
>>                    error = wait_on_page_locked_async(page,
>>                                                    iocb->ki_waitq);
>>            } else {
>>
>> and
>>
>>    page_not_up_to_date:
>>           /* Get exclusive access to the page ... */
>>           if (iocb->ki_flags & IOCB_WAITQ)
>>                   error = lock_page_async(page, iocb->ki_waitq);
>>           else
> 
> Can you try with this added? Looks like a regression got introduced...

Oops, needs 'ret' cleared too. This should be better!

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad828fa19af4..11b8e428300d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3172,10 +3172,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
-		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
-		if (ret)
-			goto out_free;
-		return -EAGAIN;
+		ret = 0;
+		goto copy_iov;
 	} else if (ret < 0) {
 		/* make sure -ERESTARTSYS -> -EINTR is done */
 		goto done;

-- 
Jens Axboe

