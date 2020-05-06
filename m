Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC76F1C753F
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 17:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgEFPoF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 11:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729367AbgEFPoD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 11:44:03 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253D1C061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 08:44:03 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r26so3272266wmh.0
        for <io-uring@vger.kernel.org>; Wed, 06 May 2020 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2NRSyIvaf2nWLYyaJ8sePmyYRYqE5xpR2Vqc3MFRjWo=;
        b=WUYa/7ZsECDpYaTV+LqgyW5wtLjw89jHlwJIMaV3HJEc84nSaW6NBeIhty7JvBahXL
         /UqIombqPaB38aG+BBwDYQiNUJSk+awAXS44TMSVjj+Ivx7AgjtOO34gfvmSpsx5LBq1
         NSa7rXS08a4EmfczfX+Fag12+86q28kzsoH3HhYOdDvfdc/Uiuv0n59NOZgW67F7mazD
         3xwJXsvOnxjI23L/hn0By74b7kKbVzKO1eg6Sx09j6A7R5IXMq3KEdCskLikOgw+Qs7l
         tzopLJ/I6VsTJdgErQLqxNFOemD/rTc5mj4zNI/rRakOVts5uPtjmd6iNitFmv35ykYc
         YNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2NRSyIvaf2nWLYyaJ8sePmyYRYqE5xpR2Vqc3MFRjWo=;
        b=W7voIDMax+xvLfJTE9aPOfOZZm5fheq9FKtMLClqJaLIlTgOPdBICelF+CwPcoOy5n
         6PA/EkdQFb1k25rYM3zS+LZBv11r8uPJjD3QpYmzDvlae2NgTCDXaIUKRLw+QnqSiMqA
         GhR8UXtqdXaPCXw6XAp0m0bfUsvJwu1mGtNK3PD+JEsYr7rsekzJ0fn799B9O/2pj1kB
         Ilyxdq88yfaAtt6Gr26EFVjmYdRGwHj58xpR33Wj7c4V039be6/5XbE3BK++jiXlm/hw
         jernWEhUptlso0hxtbcBZdbuZdSvD0e/mR5AstuYNgsV28itQ6hEvq0c6j8i8j1O5NEz
         xLSg==
X-Gm-Message-State: AGi0PubGMPqRjS29tEX06FUv3X7tvs9rRaWJbjGOsPLmpcfH7JSBbw3o
        ivos4hIkG83HaLA3Wk/hwg9WmgSa3r8=
X-Google-Smtp-Source: APiQypKJQRZ717U9yxqz4uQ0mnAeNu2ZgA8r6ctqNbD7A+G0esnyJpX+LJl0cv6MgTwHUljIkIQMDQ==
X-Received: by 2002:a05:600c:2c0f:: with SMTP id q15mr5554390wmg.185.1588779841802;
        Wed, 06 May 2020 08:44:01 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id k133sm3887652wma.0.2020.05.06.08.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 08:44:01 -0700 (PDT)
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
 <a8152d38-8ad4-ee4c-0e69-400b503358f3@samba.org>
 <6fb9286a-db89-9d97-9ae3-d3cc08ef9039@gmail.com>
 <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
Message-ID: <117f19ce-e2ef-9c99-93a4-31f9fff9e132@gmail.com>
Date:   Wed, 6 May 2020 18:42:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9c99b692-7812-96d7-5e88-67912cef6547@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/05/2020 18:20, Stefan Metzmacher wrote:
> Am 06.05.20 um 14:55 schrieb Pavel Begunkov:
>> On 05/05/2020 23:19, Stefan Metzmacher wrote:
>> AFAIK, it can. io_uring first tries to submit a request with IOCB_NOWAIT,
>> in short for performance reasons. And it have been doing so from the beginning
>> or so. The same is true for writes.
> 
> See the other mails in the thread. The test I wrote shows the

Cool you resolved the issue!

> implicit IOCB_NOWAIT was not exposed to the caller in  (at least in 5.3
> and 5.4).
> 

# git show remotes/origin/for-5.3/io_uring:fs/io_uring grep "kiocb->ki_flags |=
IOCB_NOWAIT" -A 5 -B 5

if (force_nonblock)
        kiocb->ki_flags |= IOCB_NOWAIT;

And it have been there since 5.2 or even earlier. I don't know, your results
could be because of different policy in block layer, something unexpected in
io_uring, etc., but it's how it was intended to be.


> I think the typical user don't want it to be exposed!
> I'm not sure for blocking reads on a socket, but for files
> below EOF it's really not what's expected.

Hard to say, but even read(2) without any NONBLOCK doesn't guarantee that.
Hopefully, BPF will help us with that in the future.

> 
> If that behavior is desired RWF_NOWAIT can be used explicitly.
> 
> metze
> 

-- 
Pavel Begunkov
