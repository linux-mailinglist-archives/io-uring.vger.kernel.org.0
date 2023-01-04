Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A4465DBDF
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbjADSIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 13:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbjADSIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 13:08:17 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537093AA8D
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 10:08:07 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p9so1605672iod.13
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 10:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CvtWPBzSmSfG9uiTI9yUlj0gyBN2IzC4A2BlvRXyvu4=;
        b=NW3Rg7ZMJFmsgQvqo6tCc7fcbW3CxTJsPl2kUNgsucAzEdn7gueUN8yiVIjG9BTrFB
         bLvj7+OE9ni3QIBe/aXtZ9flf2C1u0RSXafk3X2tcw7XwaGrU83VAWasDKfVRHhKXGod
         IbigJ7/0hG6WDNhiKwKQ9HXuTfKihBvGyY4EStthkRBo7Y9HZv9b4NNBeNCfSzLal+dl
         wGFCSvqRLl001rn2pqAYB743r1jL+KXHPqZa/YVtwV+rkbCpphl9iQUd2SnpAn1fCavS
         bCKP9oOJOwlvnhdWy9P12HHbW83smNJRrZpZ+lviMtMEUTuNX7Q1fqmdee4fg3FaHw0/
         T5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CvtWPBzSmSfG9uiTI9yUlj0gyBN2IzC4A2BlvRXyvu4=;
        b=DBo5S2uTyveHXKN+0XlJxJkp2UxFS5jit+QIKl/5p9loTJUl8ku0mukaL4wyb1LOfS
         4cjn9W54KXNAukcD6uUNd7457cmsNGYUPAgmv1dih8a4V7CPuSyFiInPbxmkHltuQHFi
         wGKbDxV9xI8/G41HXAUe64eO4WKMrkGHE9LQeIxCD2t9C3xKFgQppMRSU/+NQQjwAsOD
         SrxwBGJyErA1staqBX6aorBo9PwKduGox1lxJal8Wc3x5wlbdm1pej1v83U8fygf9NF0
         SV6KfvLluBbe4oYe7My5+jGDgD4qh+p80rYn2VP7/sL2095ysn6nwx7sqO6TedUFKF7d
         eFXg==
X-Gm-Message-State: AFqh2kpcCDKip7aCv4eAqbI10rcKAqL435xwVMCBI+coEQ16kq0N1Fmo
        JfJvWBawkbJNU/ZXC6abw/8+Np5RAGNhMDVa
X-Google-Smtp-Source: AMrXdXu4MJGb6AqJ7FInPz0ycm4EcLI/smUstbrGo2nklOAeWMQEknoJz9WcS3PvJCfszsI38roN2A==
X-Received: by 2002:a05:6602:2439:b0:6dd:7096:d9bc with SMTP id g25-20020a056602243900b006dd7096d9bcmr6463981iob.2.1672855686525;
        Wed, 04 Jan 2023 10:08:06 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e7-20020a056602044700b006de73a731dbsm12292044iov.51.2023.01.04.10.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 10:08:05 -0800 (PST)
Message-ID: <1968c5b9-dd2b-4ed1-14a0-8f78b302bf2d@kernel.dk>
Date:   Wed, 4 Jan 2023 11:08:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC v2 09/13] io_uring: separate wq for ring polling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1672713341.git.asml.silence@gmail.com>
 <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0fbee0baf170cbfb8488773e61890fc78ed48d1e.1672713341.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/2/23 8:04 PM, Pavel Begunkov wrote:
> Don't use ->cq_wait for ring polling but add a separate wait queue for
> it. We need it for following patches.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h | 1 +
>  io_uring/io_uring.c            | 3 ++-
>  io_uring/io_uring.h            | 9 +++++++++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index dcd8a563ab52..cbcd3aaddd9d 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -286,6 +286,7 @@ struct io_ring_ctx {
>  		unsigned		cq_entries;
>  		struct io_ev_fd	__rcu	*io_ev_fd;
>  		struct wait_queue_head	cq_wait;
> +		struct wait_queue_head	poll_wq;
>  		unsigned		cq_extra;
>  	} ____cacheline_aligned_in_smp;
>  

Should we move poll_wq somewhere else, more out of the way? Would need to
gate the check a flag or something.

-- 
Jens Axboe


