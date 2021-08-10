Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2B03E7DCF
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhHJQvx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 12:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhHJQvv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 12:51:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E69C061798;
        Tue, 10 Aug 2021 09:51:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628614285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H8Dyw2liphtid9OAXvpsx/QaSmijxYVhjCJhM1MFqU8=;
        b=sRD00csD02pHzscaDsvlkV7iPsvjkxSRR/ItEifrYAhotrRMOohh0b7dI7aLOK/VONeWtm
        2WxPm14n7CMFkB6ndt5lqe4WWfK7ubNcmmQebhRd14+K9+hCPbFuLB7RYYwy6hytZ+1dPX
        S9sQI4w1ZfTux7eoypPi92MR3tzp/fLXpie3smR5UPj2KsRZmVFj3qF6mBNtt4T1TmibMQ
        fm4bWuMswZIpl/JH7yVb26BNlUcGwWZrst9p32SdhCCk4v3xR3fqyjCRqhgV+dOf120CPG
        ya7oAy+fEiKuVlwa6O/vnrnIYZ1BoKMgBdzNWXeyQvVKBp6VA6byvIprIjm/zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628614285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H8Dyw2liphtid9OAXvpsx/QaSmijxYVhjCJhM1MFqU8=;
        b=iGZ4n4j9krudkrm+oJlo/Ps69tScqgXXm5jporoE7d7nj3O2efpqMlDIgrDx+yVXR44C7F
        1sHwAl0UcKG+WOBQ==
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [BUG] io-uring triggered lockdep splat
In-Reply-To: <f9260055-745a-4683-083a-a5e18f5ee073@gmail.com>
References: <87r1f1speh.ffs@tglx>
 <f9260055-745a-4683-083a-a5e18f5ee073@gmail.com>
Date:   Tue, 10 Aug 2021 18:51:24 +0200
Message-ID: <87a6lpqm43.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 10 2021 at 10:58, Pavel Begunkov wrote:

> On 8/10/21 8:57 AM, Thomas Gleixner wrote:
>> Jens,
>> 
>> running 'rsrc_tags' from the liburing tests on v5.14-rc5 triggers the
>> following lockdep splat:
>
> Got addressed yesterday, thanks
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.14&id=c018db4a57f3e31a9cb24d528e9f094eda89a499

Thanks for the pointer!
