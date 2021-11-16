Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E06452B1D
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 07:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhKPGlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:41:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbhKPGkl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:40:41 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7097C061746;
        Mon, 15 Nov 2021 22:32:37 -0800 (PST)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cmpwn.com; s=key1;
        t=1637044355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=grpzxEghztc5Qa8gVHDO4iWZ6E6Q47JzcLyl8tfJjZw=;
        b=RODkIUUmmlH8V+ixcJqD/r8M5N4EE/o9UdaursBlFlxIkiBAi7Gzx6ZWvKSnxZ/ZaN3owQ
        kcOQpYdgwdRiSs3KpUv2oA/965DQjtuRQ3OeNRgEnKfzZ02xyVlJlC1uwHYA3JDVxuR2/u
        zw5VQQxveqVcXQpyGLiDhI3fTSInjbK8naIgrpOkc9mn2bxuQeu8+Osa39MbnIdHV/QAhS
        1yd7SfQ50nEuSzLENCuOEQKKfFZ4nY6BRCGN1eQ+wLN66Mv5ceeloX1AT5Sw3Zys0lyTv0
        0Y2fWNi65rcr8OQHL2cH98ZPUNiNi77MQUCwwnEJWGS1sjSDKGyE5Pd/5x5KRg==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 16 Nov 2021 07:32:33 +0100
Message-Id: <CFQZSHV700KV.18Y62SACP8KOO@taiga>
Cc:     <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        "io_uring Mailing List" <io-uring@vger.kernel.org>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Pavel Begunkov" <asml.silence@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Andrew Morton" <akpm@linux-foundation.org>,
        "Ammar Faizi" <ammarfaizi2@gnuweeb.org>
References: <20211028080813.15966-1-sir@cmpwn.com>
 <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
 <CFII8LNSW5XH.3OTIVFYX8P65Y@taiga>
 <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
In-Reply-To: <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: sir@cmpwn.com
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue Nov 16, 2021 at 5:35 AM CET, Andrew Morton wrote:
> Unfortunately I didn't know about this until Nov 4, which was formally
> too late for 5.16. I guess I could try to sneak it past Linus if
> someone were to send me some sufficiently convincing words explaining
> the urgency.

I don't think it's that urgent, but I also wouldn't protest if someone
wants to usher it in sooner rather than later.

> And a question: rather than messing around with a constant which will
> need to be increased again in a couple of years, can we solve this one
> and for all? For example, permit root to set the system-wide
> per-process max mlock size and depend upon initscripts to do this
> appropriately.

Not sure I understand. Root and init scripts can already manage this
number - the goal of this patch is just to provide a saner default.
