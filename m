Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B84298A3C
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 11:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769487AbgJZKRi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 06:17:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38870 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1767647AbgJZKRh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 06:17:37 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603707455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEs6q0M6+amLhDVT3NGXs0NEgPMAQCIZm6eZQ7Qmwwk=;
        b=cpT6teSYGRFwwrHCfzU+aoyYiNYUWRHmKiIw4w/3b+TmIISq+ShWSm5eagk+Mx+aBjXmXr
        fjlZoLSl6mSRX2EXJgjrI02j95hodIyx/AbxvR6Ou2l1vLy/1aniCdUH7teUcoEpag6q+i
        upXYNbLb2htUfdwP44ApW9u8A97yQfRQ3P/u0kicGQRopI0ln4kkm10/uPmpP5hZpV4P2c
        GBf44ZFibqyBcFdBQjv3QkmMleLrZPKWFRlXwraNriaw5YxtroVfcMC2WRH0CnFkBaJefz
        mCflNndgRpVunJ+n2g2Ax8SYtemv4RsGMe/BnzCDuCKK+ydrZlqGPh9MuMTEfA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603707455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEs6q0M6+amLhDVT3NGXs0NEgPMAQCIZm6eZQ7Qmwwk=;
        b=4s1cJhwvysTLV6BIhOlkS8Jb7/Q8Ng0DdO5TwzwXcIFA6ECg0M8yLELzZ1dYz+1LLTUfyK
        CwCTgod9UpX7ICCQ==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com
Subject: Re: [PATCHSET v6] Add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <bf373428-bbc2-be66-db6b-0fa6352fa4ef@kernel.dk>
References: <20201016154547.1573096-1-axboe@kernel.dk> <bf373428-bbc2-be66-db6b-0fa6352fa4ef@kernel.dk>
Date:   Mon, 26 Oct 2020 11:17:35 +0100
Message-ID: <87mu0947gg.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 22 2020 at 20:22, Jens Axboe wrote:
> On 10/16/20 9:45 AM, Jens Axboe wrote:
> Thomas, would be nice to know if you're good with patch 2+3 at this
> point. Once we get outside of the merge window next week, I'll post
> the updated series since we get a few conflicts at this point, and
> would be great if you could carry this for 5.11.

LGTM
