Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9288140122
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733204AbgAQAvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:51:43 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33413 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729887AbgAQAvm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:51:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so9119047plb.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 16:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rzkCIZyeJNSDUeoW0WDB8K+pRYNo5VpYgzNZyHy++lw=;
        b=Mj09KchIo1UJC0dxpJ6tTc5JSmvFhWwaMSUlnYQVL2MRTzXFp7fQWkrZ8CGqGFg0OH
         mY0LixZ82mfeaG8ATkYBdbcO3SDpqeVKjyBXovlIhVQ/SSkzoZmCVi5WWr269yExnBJP
         uVTFtYm3M5nPXvniklQeotAcoejYmD+P9NlsBliabSreISdc0ZwuqkaAkl837RTeX+TJ
         2VszMUnzK6vGi/FAt5ZF5iSaNST5NiP1j4eg7lrgAvgi3JHxtzstj98Kx/jPK+olRFQX
         dYRQVVT62jCin5QG56eepAXLb5XIjZ60v5sh3ixL/leBvGQ6yfIp9oezS7VwO+qmMmJy
         SmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rzkCIZyeJNSDUeoW0WDB8K+pRYNo5VpYgzNZyHy++lw=;
        b=BxkTs4v7pRvtctiux1quuaAAxvb9Tdtb90KWguKopYdE+TopfjmrP1TkN2oKDXlUE8
         ANQ4BMKJJhDzFxM4j9SL6yTt86HUzjJwHYotovoYd37x9Tt5CBBkI9KU2/UIC6MmyFJV
         4wxLBSWL0QM+FQ0BHBtBQvR7rJqrdB9Bea6ZIN3mK7omFwdEjxaz+i9Nufm39F2z/1b4
         PEMPde5QWxKriE57XAh/3puCz4llX/Pdjhn+BB9aI9x8UNDJD66GjSb4FKKYToHnYNIb
         2JlWnX23LHVhIM6NSdQ6PIErk+Wfut8FKkRxEfliKjvsCDDvzVjk2ZOKT8A7EUra/ujY
         De0g==
X-Gm-Message-State: APjAAAWZzPm5fqyzbKbrP4uj8ZNjDxoe7UGRYFWuPdQkC4Go9Cwun39E
        mS0VqUZyo6MbTw9b1z9GWLvndoIZN+o=
X-Google-Smtp-Source: APXvYqxENfIB4K5OnJQQzypWRzHGjGvL0brA93ricVch/BwLGlMnTSwlaK9+A+6cJqfN6VEobmovDw==
X-Received: by 2002:a17:902:8f8e:: with SMTP id z14mr27512057plo.195.1579222302225;
        Thu, 16 Jan 2020 16:51:42 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g11sm25868383pgd.26.2020.01.16.16.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 16:51:41 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Colin Walters <walters@verbum.org>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18c5a50e-cd7b-cb7f-c159-322486550e8f@kernel.dk>
Date:   Thu, 16 Jan 2020 17:51:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 5:44 PM, Colin Walters wrote:
> 
> 
> On Thu, Jan 16, 2020, at 5:50 PM, Stefan Metzmacher wrote:
>>
>> The client can compound a chain with open, getinfo, read, close
>> getinfo, read and close get an file handle of -1 and implicitly
>> get the fd generated/used in the previous request.
> 
> Sounds similar to  https://capnproto.org/rpc.html too.

Never heard of it, but I don't see how you can do any of this in an
efficient manner without kernel support. Unless it's just wrapping the
communication in its own protocol and using that as the basis for the
on-wire part. It has "infinitely faster" in a yellow sticker, so it must
work :-)

> But that seems most valuable in a situation with nontrivial latency.

Which is basically what Stefan is looking at, over the network open,
read, close etc is pretty nondeterministic. But even for local storage,
being able to setup a bundle like that and have it automagically work
makes for easier programming and more efficient communication with the
kernel.


-- 
Jens Axboe

