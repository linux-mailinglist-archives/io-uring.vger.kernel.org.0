Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959EB79D95B
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjILTLe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 15:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjILTLd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 15:11:33 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A313BE6
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 12:11:29 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-797ea09af91so20086339f.1
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 12:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694545889; x=1695150689; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DozLZ6HXkkXj1pyyBlPbt4s49lUTZ6TF814kHUraJdQ=;
        b=EyQcd+vWIGOF9QI/GDSCpOYXuc/AOwat0oUyz8xrfAn/36fbBPc367Xef49q9yMmdM
         Li9lplnenzTaLF69c++zXIfrSQlvNk5iHYpgJBsMWHXHFShkrBFicHujJmMvRVEM7/Af
         IyQaEfa53bHYQM/cZgywt3Kvee5ghOQw3Vxrq2rSHs393oVZrU3X47oCO6Tna8v9GYDs
         K10bW3c5OWKbYTO8l1TA3uYVEMmOE63FslN/CSBFdgvuYPTl4YClY19taJ4OWu2EGXyb
         YEEyVF6XIrkDT7DpPVJjPNUqDGJwKCKrrReJdmbH11gjxb/cM0QwItmDK/s7/Hr9R2o5
         esRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694545889; x=1695150689;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DozLZ6HXkkXj1pyyBlPbt4s49lUTZ6TF814kHUraJdQ=;
        b=o31vY5sGJCDTlcWIXQllCh6qy3CnxAUOjWtSD9LjIUro7QoOeN4unerB54Ehq76Kti
         GFHDSCfXBDC0Aiyud80GRa4hKjKaVoKDDHYhPuvQs+EmzWuF2G/iWtrp7htMZFQZu3mD
         jrJapUKKz3U3+ZmdcIPl4LvflXmnd6AkEOnjZd4xY128EZRnaoGhHak0VrfSqBZGmj8t
         duNae1h3A+6Mp/5GZ/1wFygfA+/c+HtDtbKkIXwhuh+rNK6yFGMRXQ3JB3RmzuTfeKtp
         NTrFiweAh5nM8T8ysSwt3jyoVYm5aNwXq0v6GL71oV3uLzLrifCVxIbTuFk3v1vQFz+L
         8khg==
X-Gm-Message-State: AOJu0YwVb51wf5Fjbf89FvbF47xbEPetLgEOO3Nqm1yuWhtcmWbo5Vzw
        3DJ8esMgy1gIftNcqItXZ99SsQ==
X-Google-Smtp-Source: AGHT+IH3KqDzOlugDvVSASjNku1ralaPgI8VEZvF8q87WDxem4AgrtOyIgPUzeZmHNYi2iWuvIhypg==
X-Received: by 2002:a05:6602:14d6:b0:792:8011:22f with SMTP id b22-20020a05660214d600b007928011022fmr982346iow.0.1694545888960;
        Tue, 12 Sep 2023 12:11:28 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u14-20020a02cbce000000b0042b255d46c1sm2958849jaq.11.2023.09.12.12.11.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 12:11:28 -0700 (PDT)
Message-ID: <c3f9e31d-b5e8-40f2-9968-2d3dfb678e6c@kernel.dk>
Date:   Tue, 12 Sep 2023 13:11:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/3] Add support for multishot reads
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20230912172458.1646720-1-axboe@kernel.dk>
 <871qf3utgp.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <871qf3utgp.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/23 12:39 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Hi,
>>
>> We support multishot for other request types, generally in the shape of
>> a flag for the request. Doing a flag based approach with reads isn't
>> straightforward, as the read/write flags are in the RWF_ space. Instead,
>> add a separate opcode for this, IORING_OP_READ_MULTISHOT.
>>
>> This can only be used provided buffers, like other multishot request
>> types that read/receive data.
>>
>> It can also only be used for pollable file types, like a tun device or
>> pipes, for example. File types that are always readable (or seekable),
>> like regular files, cannot be used with multishot reads.
>>
>> This is based on the io_uring-futex branch (which, in turn, is based on
>> the io_uring-waitid branch). No dependencies as such between them,
>> except the opcode numbering.
>>
>> Can also be found here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-mshot-read
>>
>> and there's a liburing branch with some basic support and some test
>> cases here:
>>
>> https://git.kernel.dk/cgit/liburing/log/?h=read-mshot
> 
> Hey Jens,
> 
> For the entire series, feel free to take:
> 
> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks, added!

-- 
Jens Axboe


