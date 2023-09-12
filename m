Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C7A79C161
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbjILA6I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 20:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjILA6F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 20:58:05 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDDEF8AE
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:47:58 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51f64817809so608707a12.1
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 17:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694479627; x=1695084427; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuopisHJZKQqwB5NJ4dSu1h8GOGuQTlpEbF43aR1iLc=;
        b=BwSPILouucsNPqHIO3YVH9xj9YQQN7GznkHRWm9V7QTcrk5dY2HD8jvB5AyiCSXdRU
         T2rKJpoDqGFQMuX7/TuRI2kezjRtDGN4TXyU/9htChOQkBbhfhkchWv8VjaM/X50YM3r
         +q3PaR39+nK/ZSUD30fqHiN2nY+tGRTC4BAKN0F8HXHcIWCfZqgU5ntHm89tztZIi15+
         UqQZS1PKZ7XpOb+v0PNq/qu2P4OE1dPa/Ya0sPx0Uld8jEbiLBtrrm80p95vrJ8Jp9cV
         CJUnaK5aveoWrNEiSbu1tmxDh++PBJdADozZK+ixshqy8PCLEzeVkjCsoBu4eDFcmtCR
         3q9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694479627; x=1695084427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DuopisHJZKQqwB5NJ4dSu1h8GOGuQTlpEbF43aR1iLc=;
        b=YQaYZ2OKHQmp57Q48x1caV7MhjSF63tkRXMG8zduGIC8YZwzwdw23vfefPum52KgY8
         O+BwoKa/XM4CntUlaNhYoJqhZeaknb1FbZSZl7SPdac4eWVSHTL3Lq9+uIw0LYgJw/aV
         TUd8s5KZE8PZTNsEOkUz6fvZPF4oo6FKgfri0kfYV0JsiliEB7qTqxZeCeFo6EZeaFom
         7RJgtfS4Xnt7q/VPjCCD91ewxJjh3Pp8s1AZsK+lK+Vx3sesC6CC+IokA3xNYqnQ4WVc
         6rHQO5CPLnBg8WlwQMc3KNt0gxiaBdmX/9my/wFwx0YOdK7LzeLlNhqS5OOQcf5LRO7f
         NEFQ==
X-Gm-Message-State: AOJu0Yw7d2wzsYidpMiGaZ3NO2X5hRmlabri/eAkBLscTe+d5nL/glmb
        bS/nmfhH5Q208TbNVxUWXkxr3Q==
X-Google-Smtp-Source: AGHT+IHmltOv6ZYrnVIU89Me5Rodw6kBEU5R8kdu79GsxV41AsVYd+aL+DTblbe0iNxy7j5L+pKC1w==
X-Received: by 2002:a05:6a20:4320:b0:137:4fd0:e2e6 with SMTP id h32-20020a056a20432000b001374fd0e2e6mr14509461pzk.6.1694479626962;
        Mon, 11 Sep 2023 17:47:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id cl8-20020a056a0032c800b0068fb783d0c6sm3408405pfb.141.2023.09.11.17.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 17:47:06 -0700 (PDT)
Message-ID: <da6be548-5d11-4eda-acdd-403475a0f76f@kernel.dk>
Date:   Mon, 11 Sep 2023 18:47:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring/rw: add support for IORING_OP_READ_MULTISHOT
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com
References: <20230911204021.1479172-1-axboe@kernel.dk>
 <20230911204021.1479172-4-axboe@kernel.dk> <875y4g5ipd.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <875y4g5ipd.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/23 6:38 PM, Gabriel Krisman Bertazi wrote:
> (Also, things seems to be misbehaving on my MUA archive and Lore didn't
> get my own message yet, so I'm not replying directly to it)

I'm having all sorts of delays too, both last week and this week...
Pretty unfortunate for probably the most core of kernel development
infrastructure.

-- 
Jens Axboe

