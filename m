Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC9738561
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 15:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjFUNg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 09:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjFUNgw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 09:36:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C621FCF
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 06:36:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5344d45bfb0so596848a12.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 06:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687354587; x=1689946587;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pV1nGxKpTkYPMTL1V6rKtouYj4U2a1rzmVmvhKyv554=;
        b=FUhA5kRbFxEy/gAmX+taevys333Qb11PQMsG1Q0M7KFiSHUon3BDMVc1MULiYmkWZT
         81gT5DOruK8gh4fnOggfiV0uXlKq8LtfMT7D5iaMKRtfRBUFxdDNIKtAguffwe+Wcmea
         P+LCxI7TX3Xj/hBglogATHxEUjkDEvz377Gf0TaV4WVM4IIKsKGf+0oJvfreV1WNTeXc
         URrWnzZMDJ9SJdrIYzRjEJokodHrC7w5wIFI0ozeTSuARex2mvC68365AC0CoKxQpNFT
         x/ZCnSUyiGj7MmSptlH9XOXsyewKE4frTdBV5mqq2KT4V/EqBZe94oaAFyp6cAJp9Y/d
         c4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687354587; x=1689946587;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pV1nGxKpTkYPMTL1V6rKtouYj4U2a1rzmVmvhKyv554=;
        b=gYE4UiICkRP6vEVOOtFl5UJIynqSkdgZ4mvaRbxVbkKM3UiBH/ym28SeSVxVEkM+YV
         zIoL6JlmV//TeXLcB+37NuMJEdX0n/2IRqD6idAAthKUNggtkBR8JEEp7IVfkqy7sOTs
         Rha4FHIhprJG2aoDrCxDWYYC2dUO0Om/qcbDpUeyx4YzAseWP71ZIqsiLtL6btcl3nmF
         L/wIFI5gZ2z0UaxKu03XZ0aJuR6vkPt+7aX4921JY3kptrfXX/G2oRTiDkXZyS8QFxTZ
         7YfHV0UY9Nyg4SxL2niDbOKD1OnNrE1oJY46R3WQJNCFUnye20ket0j0sXHl6tzIliY8
         x9FQ==
X-Gm-Message-State: AC+VfDzVJv19MICE8X9o97wRNDe5ib67/L3xq+raxARCo7YMdFfywtLc
        ddPULcH9l9bgMdn4tsCrVi32hcFYiX+9esP3NUU=
X-Google-Smtp-Source: ACHHUZ7JKXQ3F0hzctZu2nGR+ZgtRioRaO+4A62nzmiS+VkR/Pq/cWbrtDQak6OnlPXhkSvEmbCdFA==
X-Received: by 2002:a17:90b:3ecd:b0:255:cbad:594f with SMTP id rm13-20020a17090b3ecd00b00255cbad594fmr19054126pjb.1.1687354587278;
        Wed, 21 Jun 2023 06:36:27 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id gf21-20020a17090ac7d500b002560ab7a15fsm3237460pjb.36.2023.06.21.06.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 06:36:26 -0700 (PDT)
Message-ID: <d9973134-1c3b-0938-f3eb-9489bced6a6b@kernel.dk>
Date:   Wed, 21 Jun 2023 07:36:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: silence sparse warnings on address space
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <222f3e9e-62a4-a57d-b14c-c8e9185ca1ae@kernel.dk>
 <ZJJ51Ya+i/dtGU6E@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZJJ51Ya+i/dtGU6E@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/23 10:17?PM, Christoph Hellwig wrote:
> On Tue, Jun 20, 2023 at 04:55:05PM -0600, Jens Axboe wrote:
>> Rather than assign the user pointer to msghdr->msg_control, assign it
>> to msghdr->msg_control_user to make sparse happy. They are in a union
>> so the end result is the same, but let's avoid new sparse warnings and
>> squash this one.
> 
> Te patch looks good, but I think "silence sparse warning" is a horrible
> way to write a commit message.  Yes, you're silencing sparse, but sparse
> only complains because we have a type mismatch.
> 
> So the much better Subject would be something like: 
> 
> io_uring/net: use the correct msghdr union member in io_sendmsg_copy_hdr
> 
> Use msg_control_user to read the control message in io_sendmsg_copy_hdr
> as we expect a user pointer, not the kernel pointer in msg_control.
> The end result is the same, but this avoids a sparse addres space
> warning.
> 
> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

You're totally right, that is a much better subject line. I've amended
the commit.

> (and it's really time we ger the __user and __bitwise annotations
> checked by hte actual compiler..)

That would indeed be nice... I know io_uring has some sparse complaints
on the __poll_t type that have been around forever, would be nice to get
those sorted and just in general ensure it's sparse clean. Then we could
start looking for new warnings at build time.

-- 
Jens Axboe

