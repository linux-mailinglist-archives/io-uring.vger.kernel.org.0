Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE65421848
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235885AbhJDUVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 16:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbhJDUVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 16:21:31 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1444EC061745
        for <io-uring@vger.kernel.org>; Mon,  4 Oct 2021 13:19:42 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b6so19674344ilv.0
        for <io-uring@vger.kernel.org>; Mon, 04 Oct 2021 13:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=C7jkfRDukSEsqPCYMfCEY2tJQPqCo2I9D8v2NfMPRio=;
        b=zYBAwCMRIcVGBXoCdwOqitnshB30oqAYmtfy6qpRwO9LmBLDcI78OiZiuTq3G3uXeo
         y67bS8LDo/IBSTcLk1wme68sy2dqU5MtD0QJb/dk64CBRCA5ThoLRpNQdOQ25ogxHV1b
         u8CNoAf0uEEUqbg+Tt6M39zhF1WFXjAcKV2yUvWMA/QXwtFWnoROXCXI0EarfXibuBH1
         ZMEzt6lEl8MoH3/i3Eg0tqwVb7w8B+UXZgxut+9kNnWFjh2h5H1z1vBAykc1BO9hSXdV
         +5D3Ie0IfnECYtCZ1VKoEiGTSS1K2BRr4XSkK84Xum3cIXsRRz5dpytYjVwMrsvNGOLW
         U8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C7jkfRDukSEsqPCYMfCEY2tJQPqCo2I9D8v2NfMPRio=;
        b=WofPP0X/BYLWNqE5oMd1QclJruutWNHVQvExv3rcyVbIRHOqhbf/SuCZ8ckOFvLs1e
         4LyfVuo14gbeZrFiaeILbXGwuYq/qp+Im9lnmOjU6J54l4YKhspEsUEozSFgM4r5q7vu
         2LdXISwV/ATUl+Tg2VYX5xoXR2nfzK+mym2HWnDbtpn1LgFfPDM2KMBbRStP3u4v/un+
         Jr/LTfXcX+0qmzAC/GCmQsneSK0FXAWd0RZePZOTeprZgmGwNf1rcKxXDSM/CkdF10L7
         kNgh2fmbpjda3MkCbNlY0YO5+a10NOky/0dorR6jf10onhrtZdpVLrceyEXICopdbmbI
         gh1Q==
X-Gm-Message-State: AOAM530rtwMtgTV32BwDrmW5MzMYzJsPln4gNcnEn/fjd/9FxRkuOgpK
        UYI8kJN96CfnnuGhuiMfCPHHvZfN50g6h8UHwaU=
X-Google-Smtp-Source: ABdhPJyZzBoomHra8hjIu1hACt1QorTkm+vUdBq1/s54KMvitXwFsQOZCDUHgUXSfa4UYJs8VHIJXQ==
X-Received: by 2002:a05:6e02:1c0d:: with SMTP id l13mr45635ilh.7.1633378780523;
        Mon, 04 Oct 2021 13:19:40 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c2sm2870548ilm.21.2021.10.04.13.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 13:19:40 -0700 (PDT)
Subject: Re: [PATCH 00/16] squeeze more performance
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1633373302.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c6d9fde-5073-792d-312e-a57ee2a09598@kernel.dk>
Date:   Mon, 4 Oct 2021 14:19:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1633373302.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/21 1:02 PM, Pavel Begunkov wrote:
> fio/t/io_uring -s32 -d32 -c32 -N1
> 
>           | baseline  | 0-15      | 0-16        | diff
> setup 1:  | 34 MIOPS  | 42 MIOPS  | 42.2  MIOPS | 25 %
> setup 2:  | 31 MIOPS  | 31 MIOPS  | 32    MIOPS | ~3 $
> 
> Setup 1 gets 25% performance improvement, which is unexpected and a
> share of it should be accounted as compiler/HW magic. Setup 2 is just
> 3%, but the catch is that some of the patches _very_ unexpectedly sink
> performance, so it's more like 31 MIOPS -> 29 -> 30 -> 29 -> 31 -> 32
> 
> I'd suggest to leave 16/16 aside, maybe for future consideration and
> refinement. The end result is not very clear, I'd expect probably
> around 3-5% with a more stable setup for nops32, and a better win
> for io_cqring_ev_posted() intensive cases like BPF.

Looks and tests good for me. I've skipped 16/16 for now, we can
evaluate that one later.

-- 
Jens Axboe

