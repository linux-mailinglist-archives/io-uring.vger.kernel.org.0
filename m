Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDAC5A9F36
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 20:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbiIAShf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 14:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiIAShK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 14:37:10 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB80EDF53
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 11:36:29 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id b17so2381359ilh.0
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 11:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=W4dZZ/e9WrjzOZSD1aUrjU7SvDDgtYBvwsJ63NqroSU=;
        b=mwOfoQdlbckJqd/7kBKZE5ha8IAMrmT+B1xuXgspAdjI2JvcSZeEdw2GVj1CmVX9zx
         f2FuyoAnTv1W0xrtqmA4si1/otsW37GkjvAaspPHwywHm9cJt9CYI77dJt28kAzf7iPN
         +2G3QtS8tb4jB8mAj8qON4wiGG+ni/dqEI+splAxMgS62KzJtSxO8zPaJ0ZxZeDej4Ei
         fbGXdjrCn1/aKJfNPDZ+vizRA+J0tSZFUUxPZcAaLi098G31HvE/Y/iBA8keaSVZxa+4
         lyJxiFBfG3QqiF6SsusZ6NiOnU0350CTtfeg2e/IbCw+T5G+WhIVipASdOqOxA3Htapu
         hVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=W4dZZ/e9WrjzOZSD1aUrjU7SvDDgtYBvwsJ63NqroSU=;
        b=e5sWI1Xe5HL921IbmkAd2K2o84xH9ksCWjs5d/1w71OxTxnD2IQ8bcOXjVHkc121T+
         JzqUmHiHrVhHoxi07So5bQ2axJi6scKsJEyGHoluAGyZqS0t5gc5+MCXNCiWIRWG3edt
         UcWpwJgJ2t5YFuxolmQ2GVDe5rTkwGalDGynCkY5S0lsI9BsVMrinsgpBgCH075Ql+TI
         MOohkhfL2SOET/19xqLo16+kt5TJDFRcPGA18GcZZhcFPJUJW1W+oDUGpgBNFIZE3Egc
         yzu8XYWLY42xeR5DHdaJ3qFEi6kJ+zsM6515RCzhvuQNXvLYhvDvI+X1eBVTUM01/V/F
         n7fg==
X-Gm-Message-State: ACgBeo0tc1IY82QP00v87Wo3FnK8R3pL/KwTWEwnGQCHcBaxjbrvx5G5
        vSKtmppgG7ifTE5Pptg/Z8R32g==
X-Google-Smtp-Source: AA6agR4ha86ad44RmoTGRkOFueHczN/W1jJKZakbRhL3ijQ0oJo12zaRUM6hJT0ppmZDcEmU6+DHUg==
X-Received: by 2002:a92:c24a:0:b0:2eb:6640:944 with SMTP id k10-20020a92c24a000000b002eb66400944mr6156829ilo.246.1662057389042;
        Thu, 01 Sep 2022 11:36:29 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h16-20020a92d850000000b002eb109706f4sm4660475ilq.84.2022.09.01.11.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 11:36:28 -0700 (PDT)
Message-ID: <99ee9e0a-4bf2-10a3-b31c-0a58355dece8@kernel.dk>
Date:   Thu, 1 Sep 2022 12:36:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing v2 03/12] add io_uring_submit_and_get_events and
 io_uring_get_events
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220901093303.1974274-1-dylany@fb.com>
 <20220901093303.1974274-4-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220901093303.1974274-4-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 3:32 AM, Dylan Yudaken wrote:
> With deferred task running, we would like to be able to combine submit
> with get events (regardless of if there are CQE's available), or if there
> is nothing to submit then simply do an enter with IORING_ENTER_GETEVENTS
> set, in order to process any available work.
> 
> Expose these APIs

Maybe this is added later, but man page entries are missing for these
two.

We also need get these added to the liburing.map.

-- 
Jens Axboe


