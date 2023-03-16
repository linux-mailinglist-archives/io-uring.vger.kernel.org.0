Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745116BD3F9
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCPPiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCPPiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:38:00 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89411E1FEA
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:35:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id bp11so1208505ilb.3
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678980898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AC43TMj9H2tJrdK3nkLwo2iyWc13yyi8jVkQ26Vaq24=;
        b=X1S0WMnR6LNAa9eqsOp20lD5jEGAcxc0wNMvp+SgDYoXagPOXpJD+5x0JMjn7NuZdd
         OnI3YmkozleXG8alyvBa+B4QpeW6/Riw6Xa4NXUkJLBftZNRfQWPAblCSJbys4lli0qK
         fSHm/ilqewIflfs2IrMwHUUVZd8eeawf3ae7Svrn5TaieINuNX/4rLsR7aoGcXWMp0t3
         BiBbgNORcZbk1i4oCsS0e0HsXxbCuwaMZMathu5fn23kTI8/JorrJ3A4qdGNHNiez4p+
         URXc6ABkmOCLeDZolDKey8sWZhRV8KabC1JEUXvA+skPSh8xzhEQgHmxGNe6V3k5sR2s
         wlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980898;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AC43TMj9H2tJrdK3nkLwo2iyWc13yyi8jVkQ26Vaq24=;
        b=HDrLDjRXSBPXs+b7LUBlKlPe6j/yCxQ5vIAp+I7OcARDFucpIV7ckEcja5YBIh2Avm
         MXFd6B3yL8zOBSfvlJDIH6hvO1/RvH0XRheYNMXwUrmEJZmkziReN50GpKQYkWFKvU/I
         F/Fe3if1V7Bxy+XV1sVgs6/+zWj+pClVNy2Tl3MFMmTd8M4I4jXKoUOzzB5qIbEYv8RX
         G1Rljmu1OtJ8aaeT6kAyg1LhMulYCtdQRDFotqLMLU0GyWWPXwWsIid/sVmh/q0fcSvl
         k0D3AUiZlgr2mqOxTuSZSVsjs6PyITgk2JecWoCI6BCbdCrAfe2XWOhy29QBtj6kIGpc
         r4RQ==
X-Gm-Message-State: AO0yUKWmh7o8AJDranYPsy22QhfweZSjojPIa7B5xLAlNeKQjJir/oZ3
        vtWlPktJEijVbExX43IM3ZVKXATcIFTJV9KHOCH3Aw==
X-Google-Smtp-Source: AK7set9ChqulF4reqLTJe0c4382E9kHIksroq14+qcAFbp1fS67Z19ovarACqD38q3fmooMBee/MJA==
X-Received: by 2002:a92:c263:0:b0:322:fad5:5d8f with SMTP id h3-20020a92c263000000b00322fad55d8fmr2068877ild.2.1678980897783;
        Thu, 16 Mar 2023 08:34:57 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j15-20020a056e02014f00b0032305b53b56sm2440720ilr.87.2023.03.16.08.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 08:34:57 -0700 (PDT)
Message-ID: <60432ef9-ca13-2a14-7ccd-59f1021d3e46@kernel.dk>
Date:   Thu, 16 Mar 2023 09:34:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] io_uring/rsrc: fix folly accounting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>
References: <10efd5507d6d1f05ea0f3c601830e08767e189bd.1678980230.git.asml.silence@gmail.com>
 <167898075271.29101.7596458728573428968.b4-ty@kernel.dk>
 <a0c0bbdb-81f3-fb20-a643-a6582b6fc5c4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a0c0bbdb-81f3-fb20-a643-a6582b6fc5c4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 9:33 AM, Pavel Begunkov wrote:
> On 3/16/23 15:32, Jens Axboe wrote:
> 
> As Jens rightfully noticed, I screwed the subj
> s/folly/folio/

No biggy, fixed it up while applying.

-- 
Jens Axboe


