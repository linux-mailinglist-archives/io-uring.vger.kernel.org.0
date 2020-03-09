Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB25517EAB0
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgCIVD0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 17:03:26 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:37015 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgCIVD0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 17:03:26 -0400
Received: by mail-wr1-f49.google.com with SMTP id 6so13040157wre.4
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 14:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywTacyf346MKxOAFZFGKMKs1YkxqHchcZZfMkjoIluk=;
        b=MPqiA3qY33WaSVzhfeYDVhaj0PwzywlV6dzJi/rOo+Lty8n/Ict9KxB8Gxx0Y8cfgJ
         axF3KP/APh98VRazEgmjtXeyPZYfMY3jYDlXixfJxCIOnwQQ5JSf3hcWpj8kdsnaPszW
         +5QSO27gZ+lzYMn+cfoXwAXKtgwmmZlve8OefVrCIMZ2NaQRFBT8jiYe3ccb0MOrpWzP
         JvdhSrXmY8c9mUygMXqEz8awnmsoMJ7qoEQTdSEUqSn+vK0OSUvwYiDiyPApN9o1gzue
         XzlFU6ADBCXhJH1fHNbq2MzEOgv2iDXDuROOHElfhlVH7kRVPiDwFXFHeQn7+scquzAv
         jAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ywTacyf346MKxOAFZFGKMKs1YkxqHchcZZfMkjoIluk=;
        b=gCgVMGl3PhEgTEJA6mFtcA4OlOWABW92VRhttLjovqtq5Le8XjKvI+l0H4QflApe0f
         INsUeUaPmuMwoqve9LCnd8AnkK/XU/iRxVDHd2UyJe8xhfiGGzAVpvkazYiNk4qyvD2t
         gjHZ0HdUum0EC1mycJl7+zsrWM5Keef7fchDooYEzZigNbgL/BMns1zY0PesJTAWdJ5t
         qwzlbdmg2DeVfTQLNP1QJ13s3Ex0P2GrheVnHvJCdosZRfXpd/PhO5Qxp4eseyH0maDR
         /ZHiB3Jf+FsAazr70U3YMTV4CM2WTSFMzSbb5xoFld+x96wu0QtbgTRdJnECHwqO9dyx
         LiaQ==
X-Gm-Message-State: ANhLgQ13r+ljyUErSfeeJBl8DBjn8ntiED774ixZG10SqQqMPQ7rQuVw
        uFNJjzK7pKv2IDIJ0XSXTVsCM/Wn
X-Google-Smtp-Source: ADFU+vvKvDa7e4i0eGl1Xh8E0Llb6yozAt8r+CzlMxE3IqDzwSyt0bIGZ1TP9e5PvjSfrVDwc6BSow==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr22175612wrt.89.1583787802693;
        Mon, 09 Mar 2020 14:03:22 -0700 (PDT)
Received: from [192.168.43.213] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id 9sm967542wmo.38.2020.03.09.14.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 14:03:22 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
 <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
 <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
 <9a7da4de-1555-be31-1989-e33f14f1e814@gmail.com>
 <d704bbee-c50a-ab99-bed3-17a93e06ddeb@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Buffered IO async context overhead
Message-ID: <e50a7340-845d-6261-b070-74bdf34aeab6@gmail.com>
Date:   Tue, 10 Mar 2020 00:02:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d704bbee-c50a-ab99-bed3-17a93e06ddeb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/03/2020 23:41, Jens Axboe wrote:
> On 3/9/20 2:03 PM, Pavel Begunkov wrote:
>> On 24/02/2020 18:22, Jens Axboe wrote:
>> A problem here is that we actually have a 2D array of works because of linked
>> requests.
> 
> You could either skip anything with a link, or even just ignore it and
> simply re-queue a dependent link if it isn't hashed when it's done if
> grabbed in a batch.
> 
>> We can io_wqe_enqueue() dependant works, if have hashed requests, so delegating
>> it to other threads. But if the work->list is not per-core, it will hurt
>> locality. Either re-enqueue hashed ones if there is a dependant work. Need to
>> think how to do better.
> 
> If we ignore links for a second, I think we can all agree that it'd be a
> big win to do the batch.

Definitely

> 
> With links, worst case would then be something where every other link is
> hashed.
> 
> For a first patch, I'd be quite happy to just stop the batch if there's
> a link on a request. The normal case here is buffered writes, and
> that'll handle that case perfectly. Links will be no worse than before.
> Seems like a no-brainer to me.

That isn't really a problem, just pointing that there could be optimisations for
different cases.

-- 
Pavel Begunkov
