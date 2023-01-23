Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DA36784CC
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 19:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbjAWSZs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 13:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjAWSZo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 13:25:44 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8827721967
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 10:25:08 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z31so6397837pfw.4
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 10:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ofgLvsWBJeqsKubscVLrvDnHqZm2//5AMOCN7gB/H8U=;
        b=05+/BNEecd2HlF6Ss0E4Uahn+fVEvzAJtkLn6ClV0aEZmuLvs/jeGg83cVIQo6AeMz
         ZL+OVU4cfFAWXyXk+n/aWfdSqc8zBffL7En6AhlSJ7ppEKmv79Mvjg6F5CgBJyKDImlM
         B2t+dqltbOIYUw+9mcLAU2ws5XIIs4O3bEPPDXdOYCAmFkXmrKuHpF7JZp6qeRdaLS9c
         tM5k/7THy/6xyG8LdOcxSjIcK0G6zS4sv6xPNvN2EmocNhlMXSF9mh2rU72kHPVwqbqI
         Rs+XwSVyaSpgUqxWcw/bv3d3Vw7YMp/+BphzpYcGrweeJ9M/l3pg79nek0VwrKZJkcug
         ce3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ofgLvsWBJeqsKubscVLrvDnHqZm2//5AMOCN7gB/H8U=;
        b=fMzgKuwKw63lZIXBSC6Y8NHhLMLHqlHjlrKwIZgP28q/VPmYkUCP2weJVxMf51H+Es
         pr4kH0oFSWm1Nxh1aQqD4lP26K2R+KQX0Y68yT6SutbYXSPkxs+T7YV1uoCWrSUeCRbk
         or0p+sMl8c3w2IjlzBT0VRLR6L+mvz4OXmzBogOdV0z8Jztc13Brkb/YgkOte+9H0T8l
         YkrKiq7p8StVXOJbpywRNr44MAapfOc/uALtFV+vWHYI/Ib1X2FHpa3+WGLfDgCjbVI+
         9H3OaqaiM6VlO8iGkXwSdF7NK8OMvYohGEJcvEqn6iVU8CsyHw5JQuQzsJqs2gW6+6iu
         EmXA==
X-Gm-Message-State: AFqh2koGFUH3/MLpCFpmJXMqjtw1pjU3cVPs6hbgv1bAcVoyk6/NEBMJ
        qOC0WDDpFlnS8foiVO4YJ0xAvo+2hEbWHNu2
X-Google-Smtp-Source: AMrXdXv02ph02DwbcffLwfj/k+mxcbOGiRvIdMEvRVFeYGMdoZRot1417NOhFMxHSEbXxhoEvVgosg==
X-Received: by 2002:aa7:91c6:0:b0:587:bdcc:bf0d with SMTP id z6-20020aa791c6000000b00587bdccbf0dmr6217605pfa.0.1674498307894;
        Mon, 23 Jan 2023 10:25:07 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i128-20020a626d86000000b0058db8f8bce8sm14284847pfc.166.2023.01.23.10.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 10:25:07 -0800 (PST)
Message-ID: <bb8f25a0-d3a1-3e65-24f7-e0e3966c2602@kernel.dk>
Date:   Mon, 23 Jan 2023 11:25:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH for-next 1/7] io_uring: use user visible tail in
 io_uring_poll()
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1674484266.git.asml.silence@gmail.com>
 <228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <228ffcbf30ba98856f66ffdb9a6a60ead1dd96c0.1674484266.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/23 7:37 AM, Pavel Begunkov wrote:
> We return POLLIN from io_uring_poll() depending on whether there are
> CQEs for the userspace, and so we should use the user visible tail
> pointer instead of a transient cached value.

Should we mark this one for stable as well?

-- 
Jens Axboe


