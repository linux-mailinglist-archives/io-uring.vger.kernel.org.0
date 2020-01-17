Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C201140654
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 10:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgAQJiK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 04:38:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37173 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbgAQJiJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 04:38:09 -0500
Received: by mail-lj1-f195.google.com with SMTP id o13so25754414ljg.4;
        Fri, 17 Jan 2020 01:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ABt+x9XFhNzr6FSZjAakBnTu+DOUpeXOGWTjIdDYz8w=;
        b=QUjScw3v+doeKM/rEi6fU2VZ7+8e1CZxMWnW5Ao+WPuFmyffmJy4SoZAJOnkg4K5p9
         NfWdOVfYVDY/ZnEkUtNdZ7HjLbEn1yw6T99vFNvUvoLLfLo4xMJjibKjuT1BkbBEfdJg
         cmxL5haqvMR8K75z1cLF2CgHdIM9C+OFUMuLzW33yQKpSUarUd5JrxSjNZMYoTkKZfyq
         ojrcpxGFB7TM608tybdrwsZhgdPz0x5NXMw7Vd4TPm8T+BKNwqrnu8c+j51jHbcQZ6P+
         B+NyuCBrJuExH5Ti81I6hls0EusyDRklgeB5koGRbuk48N5nXnRmElnD+KD6Kwtqlgvp
         rTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABt+x9XFhNzr6FSZjAakBnTu+DOUpeXOGWTjIdDYz8w=;
        b=gGkjA7gtOYQ/Cv9TfCKXX9seraIvmndJZJ/1ZjFLeFK9eGfx60//cF0E5h6WMKXEhC
         18lsOD8eO7izTb0LMxQ0zHdj2bRztVxzhz9Ww5/DZPZFoJp7Twmxr/V9hTrcZ/+riWto
         LmlqO0Be9QL9L3X1I+9k1VzOYc7SG1v9S7DY2K8/Pfh7RiBVNyhPbYlpoEkaI9GMIoJ5
         NtxchXG90UTeU5054h52M9IK71PWMGgJfmruOvb5OcKk6jCCju+LnuE4Mz0po1Qn9qGs
         K4RhArKIGIZAJ/sO0gq0yQECOd9900fhD5igtiP7JzAEqhroFnq5RyhrIwALNSl+pHKM
         GZxQ==
X-Gm-Message-State: APjAAAWjRHchuZKovQbwTDVaq6c1OlrcdNEH9xrFNebRpFVILRQhu78M
        MH1BnDf3UQfzl+Mur6B1NDx14psNkqk=
X-Google-Smtp-Source: APXvYqzJk9dI9tG69ql74eKdM25KWItLaeoHjCkNR9poRDcy55Un/TQgJLHLRbTiRw3ryqrTp5akkw==
X-Received: by 2002:a2e:a361:: with SMTP id i1mr4735445ljn.29.1579253540125;
        Fri, 17 Jan 2020 01:32:20 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id u7sm11721501lfn.31.2020.01.17.01.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 01:32:19 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Colin Walters <walters@verbum.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <964c01cc-94f5-16b2-cc61-9ee5789b1f43@gmail.com>
Date:   Fri, 17 Jan 2020 12:32:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/2020 3:44 AM, Colin Walters wrote:
> On Thu, Jan 16, 2020, at 5:50 PM, Stefan Metzmacher wrote:
>> The client can compound a chain with open, getinfo, read, close
>> getinfo, read and close get an file handle of -1 and implicitly
>> get the fd generated/used in the previous request.
> 
> Sounds similar to  https://capnproto.org/rpc.html too.
> 
Looks like just grouping a pack of operations for RPC.
With io_uring we could implement more interesting stuff. I've been
thinking about eBPF in io_uring for a while as well, and apparently it
could be _really_ powerful, and would allow almost zero-context-switches
for some usecases.

1. full flow control with eBPF
- dropping requests (links)
- emitting reqs/links (e.g. after completions of another req)
- chaining/redirecting
of course, all of that with fast intermediate computations in between

2. do long eBPF programs by introducing a new opcode (punted to async).
(though, there would be problems with that)

Could even allow to dynamically register new opcodes within the kernel
and extend it to eBPF, if there will be demand for such things.
-- 
Pavel Begunkov
