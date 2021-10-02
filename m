Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB1D41FD0B
	for <lists+io-uring@lfdr.de>; Sat,  2 Oct 2021 18:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233613AbhJBQUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Oct 2021 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhJBQUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Oct 2021 12:20:46 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192F7C0613EC
        for <io-uring@vger.kernel.org>; Sat,  2 Oct 2021 09:19:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p13so18335589edw.0
        for <io-uring@vger.kernel.org>; Sat, 02 Oct 2021 09:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pp5eLl89KlZUl9tH6Op21nPpnqDx9x2wgGbpW+ofgAc=;
        b=ZIXljnoDvaqruovhVMeO8ZJo+gTG+QVQvFW6VMP+BE2H0zOCE+0bVqsZX0kXamIqiW
         GIqUESTYUy7Ptej6rAeDBXnNBciXJNM9Mjn1L9wGikHPuDPyPfIDM06MkNnVRBuN0Ovw
         zNxvpUKPQkcrLQwHwrm6CoibsTTEXvcugk0vgZsTFTVQ5Q95dv2e2ehSQBTgTo5dLlaT
         piQg4EmXfm2QS2+soQzml0cZUXO9Eob+yEP4ypPn+XVg9K6x8Idx+Y/im3CjqcDJcF/B
         X0Cc+jPFIzA8d2MHVrWwwWhHbXptC4NfANpNbwLS7YoHY+a0dhhdUm8nuGrbS//cePkE
         ZYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pp5eLl89KlZUl9tH6Op21nPpnqDx9x2wgGbpW+ofgAc=;
        b=TB/7c1HBC1xFJ+LxysP3ocZjPCpGFRRGS0Gz9J048/R6Di8OiCRPXpcz+/bbEhSoie
         kqEHiBclFGw67mBwJZM70aA+OtCSlsB4mTbLba1fUZ6Uheoquyc8fpoEZTVfIpLbN83m
         BP6rdk/t24dpC42AjnaL7N8TRKbz89/Z/L266sQTo35cy9X/VushQnZ0pgOkA+vc0919
         E64aFDFG0t9NPWa55H6iEH+M+Hz/jLODb3FdR/kpjmELKwk+/0+oUAk7f74kRFUIla3U
         St+ri9d6OZJWGEd+34Jp+e0s3KvhNJRWbGSF5AUKiycQGhFxZTpDFfpYGJ6VtoCXiPYW
         Uvhg==
X-Gm-Message-State: AOAM532reZfeYc/zFGExA13buiFjjS78VaW/Yb9vjdRSy+cIrRVIR5VR
        HMi9K6/cvlXPJE5lKqyzXe6+sOEg5Xo=
X-Google-Smtp-Source: ABdhPJwrZcTNRHTGnpJFUiQy54+a1L/gruADDEd3H9NtsAQt9Kat1lzxU6Equ33s52J53mQ58Yb9jw==
X-Received: by 2002:a05:6402:1011:: with SMTP id c17mr5048180edu.144.1633191538557;
        Sat, 02 Oct 2021 09:18:58 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id di4sm4732884edb.34.2021.10.02.09.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Oct 2021 09:18:58 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add flag to not fail link after timeout
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <52a381383c5ef08e20fa141ad21ee3e72aaa2857.1633120064.git.asml.silence@gmail.com>
 <448c3b57-3c3a-37c6-5f58-b0a7ba51b497@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5840c812-f320-de95-b732-a23bd00e45c8@gmail.com>
Date:   Sat, 2 Oct 2021 17:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <448c3b57-3c3a-37c6-5f58-b0a7ba51b497@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/21 3:58 PM, Jens Axboe wrote:
> On 10/2/21 2:44 AM, Pavel Begunkov wrote:
>> For some reason non-off IORING_OP_TIMEOUT always fails links, it's
>> pretty inconvenient and unnecessary limits chaining after it to hard
>> linking, which is far from ideal, e.g. doesn't pair well with timeout
>> cancellation. Prevent it and treat -ETIME as success.
> 
> That seems like a sane addition, but I'm not a huge fan of the
> 
> #define IORING_TIMEOUT_DONT_FAIL	(1U << 5)
> 
> name, as it isn't very descriptive. Don't fail what? Maybe
> 
> #define IORING_TIMEOUT_ETIME_SUCCESS
> 
> instead? At least that tells the story of -ETIME being considered
> success, hence not breaking a link.

Agree, sounds better

-- 
Pavel Begunkov
