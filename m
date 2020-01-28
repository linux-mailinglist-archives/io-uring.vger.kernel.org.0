Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807AC14B2E7
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 11:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgA1KqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 05:46:11 -0500
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33262 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgA1KqK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 05:46:10 -0500
Received: by mail-lf1-f41.google.com with SMTP id n25so8728339lfl.0
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 02:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=O+tgbpWSTnJLUFIZQtoWBp090BgmJ8UTqzA++l7H/Oc=;
        b=eG1ooNCW9sqCP5px32Yi928LM/ul0/xr6gW2gUjCfC2yIpu/FQFT8Yviyfuov+nyiG
         yxqxPx/WcUcCpZ2aLu74JYuKH46nnoLMSfw330p/vG2HFxskwg78Kxe+3HBBwsy/kLMC
         /1NfchoIqM5vcQfnukfOO8uYNNdDC6U8qo9RHuazamjGmmBFlpE8djwyY6ab6vImoUwW
         s8hK1AhsRX3SAk+80G6h+gTde7bm1ruLcRPAg87gH1FJce7UEtw9HezXEnGtXue3Fqyu
         gTymyaEaFfgF3gjZH2FIF5gPNSGj3xlN2zekORU3EPC+OuQMitPDz/1LAhgX7JlV5LbL
         fQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O+tgbpWSTnJLUFIZQtoWBp090BgmJ8UTqzA++l7H/Oc=;
        b=ZlwZ1XpCmjmpafQX0Ogz3u+HoiHRFz1XGOIVW/MupLsg4L6MmrzuAE+6s5gKpdL6oJ
         ux2lD3jCIWhFEpFdUpgxCRxPWISIE/WLsIkjxYS4jw01qixwnwYDes7ylLEcMEzwn7rB
         1jp3hOj5B21AXtjZA5yubVrUDZS4kmvS6dQbuISf4P9OJTXxigjknHCV4in7C6GStjbp
         GNRasYUz2yn//Zb4mZzdzzviaUJhmH6jRd9A+YfInktOhUgOIn0pSV9noJnFoG7gb/fC
         GJDhtMDlIHNHM4EvzztoUFyc6PyDZJUMsbkTP27ylvnC/YqiqFpT++T008o5r9GA9V4x
         MUNQ==
X-Gm-Message-State: APjAAAU4anKecPfL0zc0ly3//HdCjP+KiUcrSFLBMUUNFl1uUF4gYT44
        wDvqxZDwLvPoXyS65C4Hy1g=
X-Google-Smtp-Source: APXvYqzad9tI9xOv7mGqzL+Kjsun3XDQ2rPoewxfChnROJm1LJX8kW48ZRN8ENieXBu8HjCi8ycD7w==
X-Received: by 2002:a19:cb95:: with SMTP id b143mr1995178lfg.158.1580208368629;
        Tue, 28 Jan 2020 02:46:08 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id p15sm9654562lfo.88.2020.01.28.02.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 02:46:08 -0800 (PST)
Subject: Re: write / fsync ordering
To:     Vitaliy Filippov <vitalif@yourcmc.ru>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
References: <op.0e3l6cmc0ncgu9@localhost>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0d073d27-221e-3f23-2ee9-6e5c52c89b5b@gmail.com>
Date:   Tue, 28 Jan 2020 13:46:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <op.0e3l6cmc0ncgu9@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/2020 1:31 PM, Vitaliy Filippov wrote:
> Hi everyone,
> 
> Can someone point out if io_uring may reorder write and fsync requests?
> 
> If I submit a write request and an fsync request at the same time, does
> that mean that fsync will sync that write request, or does it only sync
> completed requests?

Yes, it can reorder them. So, there are 2 ways:
- wait for the completion
- order the requests within io_uring

I'd recommend the ordering option by using IOSQE_IO_LINK, which
guarantees sequential execution of linked requests. There is also
IOSQE_IO_DRAIN, but it's rather inefficient.

-- 
Pavel Begunkov
