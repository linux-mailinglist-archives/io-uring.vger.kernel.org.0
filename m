Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332DF43750B
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 11:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhJVJwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 05:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhJVJwM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 05:52:12 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93C7C061764
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 02:49:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id a25so4984723edx.8
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 02:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qs3gIqdbkRBGBfsg9ypoTQYjDMosQFEn1tkf9xVNOkQ=;
        b=F0TeB10CghmHv1DlzrwsDSi/w/X1VJJUBMioIg1IsfNGc2+ApOoGzG7F5KazK2z6Oe
         9I4gM8WbLL1lPTcxdqpVwXS4c3IhVoXdRGn6oWHVGVrrFqRC2NDwfgIHj+7CXSnocOpE
         I18vGC9Jned0VY0gFjy1nght+mwMywiMz57+TW+4GR092cIIX1eIY/c75hDsZp+XeQOF
         kY/fLZlZpAe8k0Z5n8T7Um4HULGBf5UilpBTBtXffCxlIzwrUjVH1GaN7IrIxwHqeH0Q
         9aKlNPKrBxr4R7iKDxpY0DxUW56NuDiH4rZ7bbOtIrzvqvrTbT9peJVNQKhx2j4YOvI0
         1FYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qs3gIqdbkRBGBfsg9ypoTQYjDMosQFEn1tkf9xVNOkQ=;
        b=BGYl5ShAkVSJXcmvTG1og5ULcGctIqsq8+X6GvpqaZKDC+ZUBNLKrq/vj9RyBsYDqT
         xnZvDOShZWQoYaoIrLNLhqNui48tiklKKlu8AcfnpCglnkvXQFIZN62Kz00aKRaySNfJ
         PqRQQdyaeNxx1PwDPiBMdASZ6dGv0sxT2ibkDwSPmjqQHpDBGXQFKEPjNhbDYrKkP+B2
         RdMLWx3dqQ1K+h8H/MVatTXbLxgWFVKpShs2YoFeTArUMU4rHltqMG1FxWKZfD5KQHb+
         G9sR7R5wRhTmmpSSkN+XN601rvTOKZnSTxnsVio/Ma0DHvzV/NGPlkPhOe5aUYMw9TUb
         SNUg==
X-Gm-Message-State: AOAM533AzbdV8Wq57+Qr8VKo4oWxUpcXCP2mZ3cUVqppltTcagb0q8Ge
        nHQMoUvOFWTvfBIRY1lFtuFG8mkXpi4=
X-Google-Smtp-Source: ABdhPJwWIj0KM0Bmv3pPNUwsgV2cVnay7ucdDp1fn2Uw5IyZXDImaCs8m3wb5zQbO6dilfzLaybMfg==
X-Received: by 2002:a50:e1c4:: with SMTP id m4mr15499453edl.307.1634896192025;
        Fri, 22 Oct 2021 02:49:52 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id g7sm4226955edk.13.2021.10.22.02.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 02:49:51 -0700 (PDT)
Message-ID: <01fd5aeb-68c9-c30d-be9c-b8ce21f2f16b@gmail.com>
Date:   Fri, 22 Oct 2021 10:49:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Polling on an io_uring file descriptor
Content-Language: en-US
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
 <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
 <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
 <CF47UZE6WXQ6.1MZDZ8OPGM0TW@taiga> <CF5RZ29XMY8T.2FIJ64YU0UFJ7@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CF5RZ29XMY8T.2FIJ64YU0UFJ7@taiga>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 08:59, Drew DeVault wrote:
> On Wed Oct 20, 2021 at 2:00 PM CEST, Drew DeVault wrote:
>>> Surely should be updated if not mentioned
>>
>> That, or the constraint removed? The reasoning is a bit obscure and I
>> suspect that this case could be made possible.
> 
> So I dug into this a bit more, and the constraint seems to be to avoid a
> reference loop when CONFIG_UNIX=n. I grepped Google and SourceGraph for
> "CONFIG_UNIX=n" and only found two kernel configs with Unix sockets
> disabled, neither of which had io_uring enabled. Given the rather
> arbitrary restriction on registering io_urings with each other, and the
> apparent absence of a use-case for io_uring without Unix sockets, can we
> just require CONFIG_UNIX for io_uring and remove the limitation?

It's potentially problematic, even now we have a couple of other
spots relying on it. Is there a good reason why it's needed?

-- 
Pavel Begunkov
