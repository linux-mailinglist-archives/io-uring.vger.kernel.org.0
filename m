Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5B25EE0E4
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 17:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiI1Pwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1Pwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 11:52:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532D6D4318
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:52:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d11so12102587pll.8
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=SrRZDOjjz4SF5mc4QXOmhTR81Z8xsB53HFhdGPcQqOY=;
        b=WMD7jTDgDyHP3qtk+orDVQaHhTnvhG4PlXVIYzBqmLMlCP5suxZnNPVeG6BwTfpxng
         5p0Q31SGx85aCBLgp5kP5LNHAF9/lGVg8knS06nKpy0ldUqZP1brCIrnyxQ2vlRa0DDR
         2LFwscU73/UJhdwgKN0hsUwh3fmcP9ZnVYAncmkZeZqAMVWjIOWVVViMmWbDs9ObzOzE
         TH2SoWgd4IrbpD1CmJTOOQexyPPyK6IGhNQgGqzk8QcWMjyGEOuiAWL6mk1z7W1w2boi
         p7QVbnzSxoWcTpC6fUGypPX+Y5bMOfJ2JgXU67ptCqkxuxVRkd1nURvOu8HFkC1OWtqE
         dHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=SrRZDOjjz4SF5mc4QXOmhTR81Z8xsB53HFhdGPcQqOY=;
        b=FN2RAWuAq4J4MzytN1k7Csd0rvpYMzdYx+CicnTtd+06HsUn+G8L/XheCDFPztCTXW
         WZfteU81b68mLynxoPv/U6DjgLwZhEeS0SA9ZcXVKB120z4fIjxiVntQPlHdB+NhjZ/v
         N9Ehhdl+3of5mdV4mRvhHKZtgljwFXWTzimHv26maPyfDEJo5bCtqyEV1zzSgK4byP5y
         lE+APJFaxDlqH1RZSkzpS7Iv1hKJLngw17u77sqAdCLU7V4sJDZqHmGmFotmXiHQmHN2
         dXUAWnejMKOiWJTBj943LWgwPNDPmFqx4kAvyKUq5mvSc8e/FRR8ECyx0xsEwvZDJq/U
         py7A==
X-Gm-Message-State: ACrzQf329V/d4ceAiGp9BN7UBrSLgVSH6dCzxFhE/w99tXE9IPvMRYx7
        5B2+u+ReYB+NVu3L+Nn6iZ1x2AIgM/4BqA==
X-Google-Smtp-Source: AMsMyM7365evjZ4BDmHxI2k/+N7FJu+Sjac0uWUhTJrlq5Zlu8PibnSYe03aQ5Xx1iQh+KY+dCrKxA==
X-Received: by 2002:a17:902:6b8b:b0:178:7cf5:ad62 with SMTP id p11-20020a1709026b8b00b001787cf5ad62mr457654plk.13.1664380367738;
        Wed, 28 Sep 2022 08:52:47 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r18-20020a170902c61200b001789f6744b8sm3826566plr.214.2022.09.28.08.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 08:52:47 -0700 (PDT)
Message-ID: <e811328a-9a0e-1479-8183-86ed49a12215@kernel.dk>
Date:   Wed, 28 Sep 2022 09:52:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: IORING_POLL_ADD_LEVEL doesn't provide level triggered poll...
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <65aa69ee-777f-0069-03d5-d3b6cd2af609@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <65aa69ee-777f-0069-03d5-d3b6cd2af609@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 9:34 AM, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
> I was testing IORING_POLL_ADD_LEVEL, but it doesn't have any test nor
> does it provide level triggered poll.
> 
> Currently it provides a deferred edge triggered notifications.
> 
> As it's new for 6.0 and doesn't work as expected can we revert it
> for 6.0?
> 
> I'll try to write up more details about problems I hit when I tried
> to add a io_uring backend for Samba's tevent library in the next days.

Sure, we can do that, and trivial to do since it was added for this
release as you mention. Curious how it's broken, though? But that can
wait until you release some more details. I did write a test case
some months ago, but I agree it looks like it never made it into
the liburing repo and neither did the documentation?!

-- 
Jens Axboe


