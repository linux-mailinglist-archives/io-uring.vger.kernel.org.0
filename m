Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F5344608
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhCVNkp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 09:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhCVNka (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 09:40:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA3AC061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:40:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v23so6589976ple.9
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TSy1/66d299wcGd64yygGWIw2wXx7rdI7QnSHVZP8c4=;
        b=kF38I0/6/X3txP8BlfRWZ/QJ0zv2WLczuV25llWJUXXcsnRfKDTfXOUVpHgq5lBNPE
         D+boDJ9MBGaf2yjAiUYCnYoXyfwSQOKrgq1mU2XR8YNs1fKr4BDntxbCPoGG94ovC82w
         StLfH7LL1H6LE8/Qj+fwwjqt0Cn1jVkVwkB6JeN3OHYfPmw3pJja4OvfCumxCCvZ9DJF
         In+uTQW6Rm05Gc6SKkI4KTy6q7iT70bkb/YzwYnUqW/Sty6NHjR3tR4tv+IKIPzalH/a
         BoZBaFRirbbtEV61Poe57UjLOX0EI0olnwX4+S/N3rpJHQCax076AEFFUOtCk81M0zrh
         G1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TSy1/66d299wcGd64yygGWIw2wXx7rdI7QnSHVZP8c4=;
        b=oQlDOSBVehcxSTSnB7FBdexvbUMke4eCJV5WKjHxarJ9nbVRqosl3buQPsYv+ksQx9
         9hZ6h6CZsnJ3dnJfW5g4V7cuJ3r0Nnpsx/AacexQAwukLjaHA1wAHdSS0epoWV6glXGb
         LTlmFJZVeZEJrf/EbOxzmvAibFtznzDBYmOhPI4jM8gfoD7AG7Y6C7XTBSXvDH6SDCNG
         faKqmiKLTy7QhRpK7VVCap0appwRBM7ik46M+MrMNgAMySED4QL+GaTuJIbqVkQLeX7e
         +BdZLoFxr0mQk1AiWQkUbKmXwDNgDtyj0b/+6i8NMYcE3NbIZWRIMHAwlmBJdk4x05fk
         I2Gg==
X-Gm-Message-State: AOAM532a2FbJsTZ0MAhHbmJr1lFojhICiSOQVb5Y3pQ1a0Bic3lSf10U
        rY6byYBlYntBIjUjPHHZ+/xscpNTvfaA5g==
X-Google-Smtp-Source: ABdhPJzrRlfX0mF5VVSGhueNs+fOgsK4aro9dP3UQu+v3VBxWryBsvGBQKR6jjB0BVXFv1J5oTZpjA==
X-Received: by 2002:a17:902:47:b029:e6:cc11:8210 with SMTP id 65-20020a1709020047b02900e6cc118210mr23675049pla.20.1616420428824;
        Mon, 22 Mar 2021 06:40:28 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 76sm13743578pfw.156.2021.03.22.06.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:40:28 -0700 (PDT)
Subject: Re: [PATCH 5.12 0/2] minor fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616366969.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <273694fd-7d5e-1a5d-9eeb-153940d64e5c@kernel.dk>
Date:   Mon, 22 Mar 2021 07:40:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1616366969.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 7:45 PM, Pavel Begunkov wrote:
> Two minor fixes, nothing serious
> 
> Pavel Begunkov (2):
>   io_uring: correct io_queue_async_work() traces
>   io_uring: don't skip file_end_write() on reissue
> 
>  fs/io_uring.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Thanks, applied.

-- 
Jens Axboe

