Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D111925D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 21:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbfLJUn1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 15:43:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40055 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfLJUn0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 15:43:26 -0500
Received: by mail-pj1-f68.google.com with SMTP id s35so7847984pjb.7
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 12:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oscuAw5vAE51n3TxNTO2T3duoHxKljGjiqEM2pxbrAE=;
        b=EqaG3Zgh66B2ZlBqDiUF9UNe4O9r2Sra4GkvhJEOhxiWeiMaLTVvDoZipPCmw3xAlR
         L1irjKAc0/Dan9MGX3t3MH+lU5vWvTyOnp8eGzag1CI4S6IYqdhohnVy9SzUtxmVd2Vd
         vK+uG7i87wjhTJs7rPjG4/8k/FcdsP8s1OKr0bbpL+xL/p133xnwlDpzAfnbLWDpNXvA
         GDUFu7KNECeH0B7iI+pUGbG55VG5TAD1tEbTT+WTmOziFiFah4dHeLuSn5uQ/4wPK+A6
         rrztK7HmvbTulXHP69dRttHZHgE3UlM7g3Fy7Ju8ensIDDSkLG0fTmh+XeX7ScYe7ikN
         g4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oscuAw5vAE51n3TxNTO2T3duoHxKljGjiqEM2pxbrAE=;
        b=hCPyUIz6B7heyrNsBzN16/EKFwurfcnJ44m3GUSXtL+0/YPIK2wSRWL8nmO6vN3Qae
         L8cRvd+Jly0//5mHKzsw29Gr04xLyhQgnSL6+tqajNzbSJcIvgL1liuwAfuvfdsnxt5b
         zP1yckmyXA8iWl9O3hSFnmCHgCZaXU1LKGrKKwsZa/oSZ6odRan3YtztW/ppIsk3PjCG
         OpU1uhAoukh34U34CgOeMRR4pMgJVaYJ+JrsEABx/u5XMZ2IigIltBG9aN7z5cFsXE0e
         FsODv7QBfikWJQS0lZp13dwa12VIzMmhrgtO0nchE+G3AIQb4ABldevlhotn+aQ55OZL
         SP9w==
X-Gm-Message-State: APjAAAWuEvbD6MLe1CZEiEW2K1p07IqK2pdF4VMPf/Gb1Pw9T6FbLD6E
        pIMQCdLZeU5mwm0aHM6HN8pTkw==
X-Google-Smtp-Source: APXvYqzKu9FMBGbFyZa2IS3LDGGu1YYA3zjt1iFIfTrfgsVFl8Iv7l0MSgniv67vnvchLOUCY13UiQ==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr7670914pjb.113.1576010606237;
        Tue, 10 Dec 2019 12:43:26 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r20sm4535871pgu.89.2019.12.10.12.43.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 12:43:25 -0800 (PST)
Subject: Re: [PATCH 10/11] net: make socket read/write_iter() honor
 IOCB_NOWAIT
To:     David Miller <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-11-axboe@kernel.dk>
 <20191210.113700.2038253518329326443.davem@davemloft.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5a1abbbe-2230-d3d8-839b-a1c7acb46bdb@kernel.dk>
Date:   Tue, 10 Dec 2019 13:43:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210.113700.2038253518329326443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 12:37 PM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Tue, 10 Dec 2019 08:57:41 -0700
> 
>> The socket read/write helpers only look at the file O_NONBLOCK. not
>> the iocb IOCB_NOWAIT flag. This breaks users like preadv2/pwritev2
>> and io_uring that rely on not having the file itself marked nonblocking,
>> but rather the iocb itself.
>>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I guess this should be OK:
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Thanks for reviewing!

-- 
Jens Axboe

