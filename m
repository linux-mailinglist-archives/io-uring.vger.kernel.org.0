Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591E35750FB
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 16:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiGNOld (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 10:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiGNOlc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 10:41:32 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418F23ED42;
        Thu, 14 Jul 2022 07:41:32 -0700 (PDT)
Received: from localhost (mtl.collabora.ca [66.171.169.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: krisman)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id D23FC6601A3B;
        Thu, 14 Jul 2022 15:41:30 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1657809691;
        bh=mJIM2zGgD78gQfPnTLvFFsazmmE8m4nDAx4O+dQ3QR0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TpfrT7ybUq990Pru3NUwibUPmdfYNU/FPugMFvIN9KOq/p4JnnBGjUly5UwLDJPjU
         /eFpDjrdsmM3k8JeBVXxVmaboJYRrfjR942ifNvRWuq9VTdt6o173+hYSAfwgswzIZ
         WSxufC4rQyq9wJsSrppHERrcBRbhBBHm7PzR3opjDIEP7AwUuHj8Yh2TYlOFhjz35w
         h/yrdv/o1jkNN3zWkW70THW6UFs8qHplYTyOvC9NibKdPISYVnRZJ+honMu7bLeQtg
         HyyKQ+5CzQ0nqNibp65WQcTPqHz8GGdxH8PO275zBzN9lrlF4upYOb1rwFPah02sbB
         4zK6xnYcIm4RA==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [PATCH V5 0/2] ublk: add io_uring based userspace block driver
Organization: Collabora
References: <20220713140711.97356-1-ming.lei@redhat.com>
Date:   Thu, 14 Jul 2022 10:41:27 -0400
In-Reply-To: <20220713140711.97356-1-ming.lei@redhat.com> (Ming Lei's message
        of "Wed, 13 Jul 2022 22:07:09 +0800")
Message-ID: <87h73jah9k.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> ublk driver is one kernel driver for implementing generic userspace block
> device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
> ublk server[1] which is the userspace part of ublk for communicating
> with ublk driver and handling specific io logic by its target module.

Hey Ming,

I didn't get a chance to look deep into v5 as I was on a last minute
leave in the past few days.  Either way, I went through them now and the
patches look good to me.  I'm quite happy they are merged, thank you
very much for this work.

Just for ML archive purposes, the entire series is

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

:)

-- 
Gabriel Krisman Bertazi
