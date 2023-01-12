Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC25C6669B6
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 04:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjALDk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 22:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbjALDkY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 22:40:24 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072E43AB06
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 19:40:23 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y1so18940793plb.2
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 19:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgxiRfkS3HR53cHlURdan1SczDBcVnY/mcCP2El3Qto=;
        b=hTtKvsKMvGkYQobqOOafnPSR9s2mfyK1KpswzkXH2IHT/y3IH4EaQ+l65EVPLdPKhJ
         tL/qPyTC9N2FMr2j9zk2imMPQQwjEBqSyQBWGc0z62zWzvaOWk2qPgqPTkrbAcomE3T4
         /vH1GGB+rLxoVuX3qaX50v38+6Z+BXZFpDFzPEo4lxwkg8Kl903+l/QTljb8BJVaOQxq
         xI4vqBW/y5Gk2qx3RS6QPKNX4HyL0EDXx2p1Qj6mFIHzq7kGDM+jTbVLdcrDOeh1BX3l
         i1dm9k46fR9nHbusiQQ3al3YZxwBPf6sDYfAOxkj5vsRGrrNub3Vyvko/y9AER0D8DD1
         j/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgxiRfkS3HR53cHlURdan1SczDBcVnY/mcCP2El3Qto=;
        b=o+zZa8oXt8O9Er49aMRnDM422ZqkpuvgaMzE5ZZigRypi5J1IXLvC8ntNqk79vu07v
         iHbk/DW7s/B7hxduCUFbGYq4iSnbK5RRwNlTK0VWPVe3u60i37ennTU5X7/tF+48+Kc8
         rZUG4Bpo1w1sIdJFyON/fVyY4VMguxqo0OZ5VFnbDNSPnlQXiKjrm7TBfCAKrZM5M+1q
         bAErN0PKYedG4l/6RX+cU5Vw6m1J9fZgW7AtwgUNg53UkXiUCFOl8MfmDoyWOumjJWje
         jnp+Cod0I7k+g0NBXkvY71zBWlMD5a+53IxlRocZcCKN+mfYOwRQ/12l/utccSABa1MN
         x/yQ==
X-Gm-Message-State: AFqh2koOniaWeoVoSRERGtonTIW17PA61uZw3mi8Yn2oSXvxhgqsmhIk
        YLXVEJLaYRCZh8Bmn0HCGG/pdQ==
X-Google-Smtp-Source: AMrXdXvYvcNoWjWmiwpQmq7bwT5b4fDzT8G3inFQ0S0fYg0sI0lZrJhiqVq5jm0+UkDD2btnt8aXCA==
X-Received: by 2002:a05:6a20:1586:b0:ab:e177:111e with SMTP id h6-20020a056a20158600b000abe177111emr26602974pzj.5.1673494822481;
        Wed, 11 Jan 2023 19:40:22 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z6-20020aa79f86000000b0057726bd7335sm4207975pfr.121.2023.01.11.19.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 19:40:22 -0800 (PST)
Message-ID: <24a5eb97-92be-2441-13a2-9ebf098caf55@kernel.dk>
Date:   Wed, 11 Jan 2023 20:40:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: IOSQE_IO_LINK vs. short send of SOCK_STREAM
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@gmail.com>
References: <Y77VIB1s6LurAvBd@T590>
 <b8011ec8-8d43-9b9b-4dcc-53b6cb272354@samba.org> <Y79+P4EyU1O0bJPh@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y79+P4EyU1O0bJPh@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 8:27?PM, Ming Lei wrote:
> Hi Stefan and Jens,
> 
> Thanks for the help.
> 
> BTW, the issue is observed when I write ublk-nbd:
> 
> https://github.com/ming1/ubdsrv/commits/nbd
> 
> and it isn't completed yet(multiple send sqe chains not serialized
> yet), the issue is triggered when writing big chunk data to ublk-nbd.

Gotcha

> On Wed, Jan 11, 2023 at 05:32:00PM +0100, Stefan Metzmacher wrote:
>> Hi Ming,
>>
>>> Per my understanding, a short send on SOCK_STREAM should terminate the
>>> remainder of the SQE chain built by IOSQE_IO_LINK.
>>>
>>> But from my observation, this point isn't true when using io_sendmsg or
>>> io_sendmsg_zc on TCP socket, and the other remainder of the chain still
>>> can be completed after one short send is found. MSG_WAITALL is off.
>>
>> This is due to legacy reasons, you need pass MSG_WAITALL explicitly
>> in order to a retry or an error on a short write...
>> It should work for send, sendmsg, sendmsg_zc, recv and recvmsg.
> 
> Turns out there is another application bug in which recv sqe may cut in the
> send sqe chain.
> 
> After the issue is fixed, if MSG_WAITALL is set, short send can't be
> observed any more. But if MSG_WAITALL isn't set, short send can be
> observed and the send io chain still won't be terminated.

Right, if MSG_WAITALL is set, then the whole thing will be written. If
we get a short send, it's retried appropriately. Unless an error occurs,
it should send the whole thing.

> So if MSG_WAITALL is set, will io_uring be responsible for retry in case
> of short send, and application needn't to take care of it?

Correct. I did add a note about that in the liburing man pages after
your email earlier:

https://git.kernel.dk/cgit/liburing/commit/?id=8d056db7c0e58f45f7c474a6627f83270bb8f00e

since that wasn't documented as far as I can tell.

-- 
Jens Axboe

