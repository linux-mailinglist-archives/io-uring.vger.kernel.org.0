Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54873294053
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 18:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbgJTQSg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 12:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732501AbgJTQSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 12:18:36 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0638FC0613CE
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:18:36 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g12so2879197wrp.10
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fzY8/AJPqF6hwTWb2jujFHzgHPBcjVz96KZ8XfzDfwI=;
        b=afkoGPpkhtPFNvaJy7n1ISz2t8q8qyA3j9uB5LHHekCV5ZGKIJyFYL+dedgyX+Hrys
         8YzDOpkvaNp/JqQSPkRLHcHFtlteh5pNd+M16hYFJhwX+PYOYnztKFWALFTBntxeElRL
         sFgB7E7VLiA3DtCyIaIZZJFRPANcNbY/uZ7PleZbUyw8d+pxt2aED/gNJjaQgWMm1ixn
         eqmfKBUiiArGuzqGIB0O27r5uVp6tBXS+Jsozb8wAjB7eb0CLugEM9fl0xX5eGegFA3e
         S+qyNtXrXLamBri3fBv2HoRVsb+DLrw4aMGmzBzY7m3ZjergG9T8utSv1O9qjbTDKVNd
         Ilkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fzY8/AJPqF6hwTWb2jujFHzgHPBcjVz96KZ8XfzDfwI=;
        b=BMEtS8oJ0yQEP3ZXLckRhDQhC/maOlGuzPw0h7BPEonA9EZTmX0Mr2i9T+skCdhUPp
         rWxjompQ7slnr88AsRgv5xm1E/+UsQl2Zhm+Flqk/OZD62A8Nmxq9X1aYk049ASkEzqb
         kZgo5L4L2mzmyVbN8UuKF6iXqkv+L7EOSBfHx+j2ghAEzRCb6iH/wGV7+xjMMEK1EiGm
         4p6lJUeefJtdeExvELRqIrCSbv5Eg1UJH9J5qsQZkUUH6UJDzTd4WY1ORsVZjJ/epXzQ
         1zGW9m8YH8VR/2R0yxGVkHvCj3eAoXvXlkjz0KtIS7bWRz2D1PWDCVGOcRh0IvSN/Snv
         93MA==
X-Gm-Message-State: AOAM532Uz120cG6/Zjg7TcMVzNsVNOzpZ8uvpyCY+ouUvtoIKHlOKcCn
        QO4qypVWPls9UWUSPIEDm+J2519nDWUqdQ==
X-Google-Smtp-Source: ABdhPJyxXyym6KmnkXBkBIWPrvgCmSZG01t/X04ptA0JllBPc4DRMhk3giex6N/JjNngE80wbed13w==
X-Received: by 2002:adf:e4ca:: with SMTP id v10mr4655049wrm.53.1603210714358;
        Tue, 20 Oct 2020 09:18:34 -0700 (PDT)
Received: from [192.168.1.182] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id y21sm3187539wma.19.2020.10.20.09.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 09:18:33 -0700 (PDT)
Subject: Re: [PATCH liburing] test/lfs-open: less limited test_drained_files
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d6fd0e761f9daafcd4a8092117dfd751c94f2a06.1603122173.git.asml.silence@gmail.com>
 <f7625f7f-86e5-fd4a-4f71-ae76110dfd68@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2b69f0fa-ba17-d9fd-e83e-e73db32c010d@gmail.com>
Date:   Tue, 20 Oct 2020 17:15:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f7625f7f-86e5-fd4a-4f71-ae76110dfd68@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/10/2020 15:12, Jens Axboe wrote:
> On 10/19/20 9:46 AM, Pavel Begunkov wrote:
>> close(dup(io_uring)) should not neccessary cancel all requests with
>> files, because files are not yet going away. Test that it doesn't hang
>> after close() and exits, that's enough.
> 
> Applied with the below incremental.

Thanks! My gcc 9 didn't warn me for some reason.

-- 
Pavel Begunkov
