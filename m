Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37AD28EFEA
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 12:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgJOKOp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 06:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgJOKOo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 06:14:44 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7284CC061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 03:14:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e23so2575934wme.2
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 03:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vDpTeVUL6ZBBKiaeJL0+InmhAMK6VjE45/S12IvvCVU=;
        b=ENHSzPB+2bkKf3XMpF1+cnfPdQgGhgMI9FhttBAvo8oS/W+QxLVJQWfqJ2244RaOii
         364XYyMDpsztNpWZ8ENZ1/sEi/tu2r+GGfd0oSdM2+Yz8s6E+92LHpHk/M/+h3t3o49m
         1B0/O/qgAh4q9IlRrvKYR1Ogw1i9PP23VW9Of2GAxERU11lU8YyP6uKpZW9B17ju97cc
         JGBpqD3bZ0n/UOZQYqRpt0iU7fq130b1np7jfR+cptVo3xJNzwkia+MMQhy6zMLqFl6X
         E5MB7VsAZjg4JvZG/On4T2PhSr2/mWOGGRd1cQ9xdzgKeTgzgts68Nim9adBgjK1C/eN
         45BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vDpTeVUL6ZBBKiaeJL0+InmhAMK6VjE45/S12IvvCVU=;
        b=r5xnR0W1d/M+oz7qviPsxnR1zQyXVkfhKwWXpJhWwcF0R4LsAoIIOMY1C7Wn9koEt4
         NRco7Cas7obWL5GDsd8YV0G0545Jragfepa7phTZMFPS9wVTrDn0d50RRfg1MviUhPDV
         Kka1FBguisY5J9vwQ6cWB9RqR/K2HywAtIK3QZlLKpx2SXljF0Cs73ybHlHFvZQD2VQv
         XQUU45RL59THuRiwQ6yBMq+nF1GP91ZltujgUhGYJyvEpKMDSoEHSzopthHgUDrb71Qw
         +ZvEmwJthQLdPvkzSNDb+1O5S4hZ8bnHmPFplPTcGmTeu5GpHyxVYz9AM0eBqjh6UpyZ
         OJIw==
X-Gm-Message-State: AOAM531lalD33vlEfBCsmPJZNRrS5jEqwWpFkTOrT8pN35od/yDs6LQd
        nNLUo8zz1QnzCEBt8R3cNcY=
X-Google-Smtp-Source: ABdhPJzbOioaY+BXpK7ONSUPib7iSBVfMwkpo5YJRdBRrIVCA0qRFj5deexr93h0h3vgcH3dcJkAbA==
X-Received: by 2002:a05:600c:29ce:: with SMTP id s14mr3112312wmd.47.1602756883168;
        Thu, 15 Oct 2020 03:14:43 -0700 (PDT)
Received: from [192.168.1.125] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s2sm3753798wmf.45.2020.10.15.03.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 03:14:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: optimise io_fail_links()
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <cover.1602703669.git.asml.silence@gmail.com>
 <3341227735910a265b494d22645061a6bdcb225d.1602703669.git.asml.silence@gmail.com>
 <20201015085319.GA3683749@ubuntu-m3-large-x86>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7e293894-823c-5b91-1b55-f5941c82d83e@gmail.com>
Date:   Thu, 15 Oct 2020 11:11:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201015085319.GA3683749@ubuntu-m3-large-x86>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/10/2020 09:53, Nathan Chancellor wrote:
> On Wed, Oct 14, 2020 at 08:44:22PM +0100, Pavel Begunkov wrote:
>> -		io_put_req_deferred(link, 2);
>> +
>> +		/*
>> +		 * It's ok to free under spinlock as they're not linked anymore,
>> +		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
>> +		 * work.fs->lock.
>> +		 */
>> +		if (link->flags | REQ_F_WORK_INITIALIZED)
>> +			io_put_req_deferred(link, 2);
>> +		else
>> +			io_double_put_req(link);
> 
> fs/io_uring.c:1816:19: warning: bitwise or with non-zero value always
> evaluates to true [-Wtautological-bitwise-compare]
>                 if (link->flags | REQ_F_WORK_INITIALIZED)
>                     ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
> 1 warning generated.
> 
> According to the comment, was it intended for that to be a bitwise AND
> then negated to check for the absence of it? If so, wouldn't it be
> clearer to flip the condition so that a negation is not necessary like
> below? I can send a formal patch if my analysis is correct but if not,
> feel free to fix it yourself and add

I have no idea what have happened, but yeah, there should be "&",
though without any additional negation. That's because deferred
version is safer. 

Nathan, thanks for letting know!
Jens, could you please fold in the change below.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66c41d53a9d3..2c83c2688ec5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1813,7 +1813,7 @@ static void __io_fail_links(struct io_kiocb *req)
 		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
 		 * work.fs->lock.
 		 */
-		if (link->flags | REQ_F_WORK_INITIALIZED)
+		if (link->flags & REQ_F_WORK_INITIALIZED)
 			io_put_req_deferred(link, 2);
 		else
 			io_double_put_req(link);


-- 
Pavel Begunkov


