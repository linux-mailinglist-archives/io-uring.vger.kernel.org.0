Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0916427DC
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 12:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiLELyg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Dec 2022 06:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiLELxy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Dec 2022 06:53:54 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D67271
        for <io-uring@vger.kernel.org>; Mon,  5 Dec 2022 03:53:52 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id h28so11076867pfq.9
        for <io-uring@vger.kernel.org>; Mon, 05 Dec 2022 03:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z83w38StXzU1P1Cz7AnEqDv/mazf2ipZcRXFKrAymq0=;
        b=hJ0+bzorRaiebteLDBq3nNF1e66VdDbfjHou6f6oXOdxxyFT5FQ2IXWGd068eZRaoO
         Ns9LlyBGMRYOMdqpDEo8ngwsVTLPbOQNk+kKcCRNu4XKDTVaOK7qpB+57CLw413aLSdN
         EymQXgERpYWteWa2Muf+UarTWy/gDMSQ+FRWBALmG5/aqwvoiIqWef11X8+j1I9MfdgU
         TJ6oeLK+VM5mMLg5BfokkrvyJo0dUZnaXs04FKc71JOFOngPX7Zc8socbCQgyBIbvyxE
         9zAarH0L9SMbuBYtiwGZFCzmOB0OvraJ96sZV5g0TGPoD1oxx2RTazZ1USHvppt5X32l
         6tpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z83w38StXzU1P1Cz7AnEqDv/mazf2ipZcRXFKrAymq0=;
        b=vDTuY7+4Ds5PFRaPQdIHZ7km5jAxGnzgfOWM4+l6vWpsvvI2mkRDyNJTxdeAnXRh8z
         1h75JJ9cRu0PSc/NaByvBwpE1/rxlCsWwW8mxJ1544PxNgNJHjixAvvS5n0OISO0w2LI
         0rqhQ7T9Td3x9Z+YWopGtlTtPxDJ1qKJu8We5K2rSqroUPM/oJO31fNDWr4zFqMUg2JP
         /VpbI1yRwgQT4VklOQdZU8Zq+TZ0aK37Q1ukSQ3aVmxgQckwmFWq/a3zGnSCIUUpHfya
         cpHc151fZV5MjBmXexOVigTKbGm0RezCUSi6z6de+J7gr0KB/+mfDy7LvMuzkJJuh9DJ
         /mDQ==
X-Gm-Message-State: ANoB5pk0IwYZSgJcOPFZ7mxHWahdeI1e480fUrfpaVjONtUKgK6C4vVL
        dimfC9E2nKRLeJfWWut044Kir+nbMnUhssOq7c4=
X-Google-Smtp-Source: AA0mqf4GxQRfJv/YrtzWZdTyXSnmTTXdh02L/nMmt0ucIGYkOZPcd7RrV+deC9B3TCyaDZtHUsoiIg==
X-Received: by 2002:a05:6a00:4509:b0:562:641b:c1b2 with SMTP id cw9-20020a056a00450900b00562641bc1b2mr68807019pfb.8.1670241232196;
        Mon, 05 Dec 2022 03:53:52 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f2cc00b0018982bf03b4sm529040plc.117.2022.12.05.03.53.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 03:53:51 -0800 (PST)
Message-ID: <3b15e83e-52d6-d775-3561-5bec32cf1297@kernel.dk>
Date:   Mon, 5 Dec 2022 04:53:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670207706.git.asml.silence@gmail.com>
 <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/22 7:44?PM, Pavel Begunkov wrote:
> We want to limit post_aux_cqe() to the task context when ->task_complete
> is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to another
> thread. Instead of trying to invent a new delayed CQE posting mechanism
> push them into the overflow list.

This is really the only one out of the series that I'm not a big fan of.
If we always rely on overflow for msg_ring, then that basically removes
it from being usable in a higher performance setting.

The natural way to do this would be to post the cqe via task_work for
the target, ring, but we also don't any storage available for that.
Might still be better to alloc something ala

struct tw_cqe_post {
	struct task_work work;
	s32 res;
	u32 flags;
	u64 user_data;
}

and post it with that?

-- 
Jens Axboe
