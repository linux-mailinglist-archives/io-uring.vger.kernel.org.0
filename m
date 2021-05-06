Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAA37515F
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 11:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbhEFJS7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 05:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhEFJS7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 05:18:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49631C061574;
        Thu,  6 May 2021 02:18:01 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620292678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZcmkqlUylzbd3OMjA5tEcjCZWOb3uLI4wszbu/QMDdA=;
        b=pTxZiMW8fMVAvtX4OcqL0lRGMDH+idxl0h5uAnsf2QVf29ScCs8GIWlkUWHU9e1Lcb6I3o
        x0gak6589F/KTg5JzzjtYvjJsFMNV03nQHS+KftaJi028jnXr7aRYgRJfQ58RGXdkwMp5u
        SsqDfsQWivhdpoaaSpMxT4sfBO4rhyRMKpS9SFpsgDzX1rdGm9qfBC7uqg2T38LyIXGVX7
        6pO0PBYQIimY0kkgazs+w141yUz+uWQe1haKD3nQZpbFf0PzUbrofUKsaVWnU6eQsPer/D
        UlVCpZZEGC7r944EnCi7KUlf4gDpih4Ze0iGohxSpwm3lSxZt6ZLf6kAcx2fcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620292678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZcmkqlUylzbd3OMjA5tEcjCZWOb3uLI4wszbu/QMDdA=;
        b=/pmsrQuVa/AWf+JQDp9slyDj6xABmiEb9mz10RFpaM4czEv6pgI4pskSrQvmF/4+xxRInN
        84IHCgi/QGH8AZBw==
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] io_thread/x86: setup io_threads more like normal user space threads
In-Reply-To: <ff1f6a6c-9a11-acda-13cc-e67440a85d87@kernel.dk>
References: <20210411152705.2448053-1-metze@samba.org> <20210505110310.237537-1-metze@samba.org> <df4b116a-3324-87b7-ff40-67d134b4e55c@kernel.dk> <878s4soncx.ffs@nanos.tec.linutronix.de> <875yzwomvk.ffs@nanos.tec.linutronix.de> <ff1f6a6c-9a11-acda-13cc-e67440a85d87@kernel.dk>
Date:   Thu, 06 May 2021 11:17:57 +0200
Message-ID: <87y2csmda2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 05 2021 at 17:49, Jens Axboe wrote:
> On 5/5/21 4:07 PM, Thomas Gleixner wrote:
> Thanks, I've added that and modified the subject line to adhere to that
> style.
>
> Again, I'm fine with this going through the tip tree, just wanted to
> make sure it wasn't lost. So do just let me know, it's head-of-branch
> here and easy to chop if need be.

Let it there.
