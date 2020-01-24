Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1444C149039
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2020 22:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAXVhg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jan 2020 16:37:36 -0500
Received: from mail-il1-f176.google.com ([209.85.166.176]:41742 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgAXVhg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jan 2020 16:37:36 -0500
Received: by mail-il1-f176.google.com with SMTP id f10so2749697ils.8
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2020 13:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RsGM5ieitVW2WhsfLB6Adtorh5HazyoW3xes0yXxpOQ=;
        b=Kmpp+I0cK9IzNjK3Q+vlLpmi90KiEMTrMBHjthBb1EuxWJDfUUYihAme3mz1OP91hv
         5BS9cGomtTOu8CevVrx1bpMdbg1eyFpkHTFisSg4Q8inYBP1h/cwHIBX9Ep76lpZktbG
         tvdNl5iL8zSKxV9/elG4vOUxle44uhTeCQb5qxSvLfanL5GYAbdgXnA0Asgs+sZ4IfYn
         zkr+49ZQ+xA5n9dFGtI5ygPu8f9DDxUpYY+0WTqGixDUUbBcEnEfTxLXXLMcANYINUQf
         /aG1YQaRy9AxAYq4ukxAYYeak99DKr7QquHAzn+G5uJjW520WqDiPKs8My+5S8D2N2ya
         i3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RsGM5ieitVW2WhsfLB6Adtorh5HazyoW3xes0yXxpOQ=;
        b=NdpUQNtMTTZLjKHDBIAgGFfeKGv/e46bBlxUoVKSjzxkUTKfLW8VQvTzuMiuQw3goU
         kQxvO7Oa4tcwmneH8KjUkJSQMmuKhbYnUOVtECnpU6VjAYF4B87BtkpJcwup3Uvo/h2C
         uAqll8RkK/YWyWjPAoo7VnCtI7kPrg+8vvCBcYetZTCGaUIMW++wu5ExdzeMwUl+NwJ5
         Kkrbphi9t1QmlL0tFwrgs5tQhpk2wTzs5CtoGx4RhihaklzVMvElZH3ortFrfacFuWW6
         F74Jk7nKIGWiuYg2133dAeiv3TyKVfI8eVMQykR5RMJ/knsmXDSKFXWhUhfsX583XWmC
         9JiQ==
X-Gm-Message-State: APjAAAUhgdmAGy/n4cyATK+sDlRedNnH81uTg6RKNJLsqPOyknqjK5D8
        JXw66FCmvdyMAGtK95QqwTQQt8fIaVI=
X-Google-Smtp-Source: APXvYqy70WuvLppzXa8VnkADTUXeCOGNEX+TXdfN+bEpO7hvOX1DzXxDhzuUWCeu6XczM90tH9gl/A==
X-Received: by 2002:a92:4d3:: with SMTP id 202mr5084937ile.291.1579901855346;
        Fri, 24 Jan 2020 13:37:35 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x13sm1422753ioj.80.2020.01.24.13.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 13:37:34 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <2ba85190-6888-585c-cd42-4cbdd112dee1@samba.org>
 <1b101121-90ed-0074-0787-eecaeca88369@kernel.dk>
 <b135e56f-1741-10af-6f2f-b3f1cd19874b@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d05bb42c-296a-a680-2d84-20721d546635@kernel.dk>
Date:   Fri, 24 Jan 2020 14:37:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b135e56f-1741-10af-6f2f-b3f1cd19874b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/24/20 12:14 PM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Trying to avoid something that is too tied to the internals, but workqueue
>> (or wq) is probably generic enough that it can be used.
>> IORING_SETUP_ATTACH_WQ?
> 
> Ok :-)

It has been done!

-- 
Jens Axboe

