Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D7D1BABEA
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 20:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgD0SEg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 14:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726230AbgD0SEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 14:04:35 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B50C0610D5
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:04:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b11so21627584wrs.6
        for <io-uring@vger.kernel.org>; Mon, 27 Apr 2020 11:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mSwWUACibr71u0By7as7rkNelopBe77HY1q86TmaSWw=;
        b=aMcjEVHK8w7CwOfnia8j1N2xo7cU5F53HPIgkZH19ouo6DxT3kS/6hHJRjY12Yd+J/
         GXNMXlh5MsGS0W4YV4UAAYMACM3+a+DdjWeBlLVFZfLCnbuLYRR+NERWupp5iDCDe7A3
         DqNDsUerD6TwhNWBVbqoaar6udC6p3TSOsGdP3hrSDxYJtzn+rRWxOQetTbStPVVmp+E
         HqaGaR9IT8TduAhilSqLqXtIE6EY0n9TLnZyhnWUifxrGxRNXKAZCMU2CLWZJsTWM8TV
         QInCW+XyfxoSoXAjSYexhKfsAe3hP/t3scGcg7nMKEmLfA1/LlzghBtX07b0AGe6joJ4
         XDaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mSwWUACibr71u0By7as7rkNelopBe77HY1q86TmaSWw=;
        b=qzHZcUTVDw49SSqL6I6CuDTaSQHhbB+sSCBkgONNC5sNUoiUNdhjIe2bHbZWz75q22
         4zhUkA/Yhe5f8Nwo8fFj8VS1WVUoG6N4Ib9N9EYgzSN0g5wLZIuIIvQdov+nGXcm+fJ9
         pyN4kWB9s9Eg8nfCKQloeINJIacKlLI0btSzJs7y7FI6xzqW+rmeBTTKwr4iRzCj6V7L
         rLQd+HL/WbgPG5NlCotdQlc/zg/Ns9cdL6wocOFeotN853E46GhOWDboBaxfAumfAIB0
         QRXbNjl3APeAeZM+c92xF4jFgAPpIgUs5nedbD2qJsYqXmdSePGBG/Q48vj/1pqBLFT4
         CSoQ==
X-Gm-Message-State: AGi0Pubpp+cTTnUrQK5t7h6U4fS15VBWETuhCRoDWKln4+8yoR5sCBOT
        c1+pmlyqZB9JRemVXV553F9IuwBr
X-Google-Smtp-Source: APiQypLlgYJYWvVC2Yo0nWJFK2HIEgO8wqZ+OkVZH3pEVR2oYvBl9JR8bf1411705I5/ZUh7D5Fu5Q==
X-Received: by 2002:a5d:400f:: with SMTP id n15mr28594247wrp.344.1588010673490;
        Mon, 27 Apr 2020 11:04:33 -0700 (PDT)
Received: from [192.168.43.25] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id l6sm22215868wrb.75.2020.04.27.11.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 11:04:32 -0700 (PDT)
Subject: Re: Feature request: Please implement IORING_OP_TEE
To:     Jens Axboe <axboe@kernel.dk>, Clay Harris <bugs@claycon.org>
Cc:     io-uring@vger.kernel.org
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
 <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ed2433e5-a8a7-65e2-8241-5900bf5e3b5a@gmail.com>
Date:   Mon, 27 Apr 2020 21:03:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/04/2020 18:55, Jens Axboe wrote:
> On 4/27/20 9:40 AM, Clay Harris wrote:
>> I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
>> didn't go in at the same time.  It would be very useful to copy pipe
>> buffers in an async program.
> 
> Pavel, care to wire up tee? From a quick look, looks like just exposing
> do_tee() and calling that, so should be trivial.

Yes, should be, I'll add it

-- 
Pavel Begunkov
