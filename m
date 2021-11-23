Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCEE45A3B0
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 14:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhKWN2f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 08:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbhKWN2f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 08:28:35 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57235C06173E
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 05:25:27 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id jo22so14883718qvb.13
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 05:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f6bH75B5uISe754dD7QVxSQqAX2xbC77T+3hEu0cg7s=;
        b=ZAIcvL7QYRTkyqM+UDLXRaCX+Pmpvh5KGYJtlJ/8CtTMaajohDKyBjLo+LXPQsQ8Yw
         XJc5afxG/RkwB16aWB8+I6/k0XUX2B/wj17o9z6XmNpyTEaJXlMb5L+LByJJ6UmseguW
         Ov+d4K4llr4KbsOc4yNahw4VUaa0J/UPstNjoW7aBSVvDLkG7J98XrFQn5eqLhT6y944
         lOF8fXpAFO4n/SjRKOZQ3F9nKAhVWibTWB41gsH8TKX+2XumUIPwcmEZNpRGEhINzKmB
         iHzWXuUr3Cl5dq8DO8NsvFO+gy7mHuUAE9kXTyJqqdpr7Mb0Ur5NVMTJS+j87RGmZH5G
         r55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f6bH75B5uISe754dD7QVxSQqAX2xbC77T+3hEu0cg7s=;
        b=kqaO19I6qL81whqnuhY0ShagKRwLkm+/omDCsBzTo6GvnYi4LiW0JvZgRJWvxBqVXD
         5d35VtOxsucNvp7c4ecwJmEiCDTP0XsPDQLZZ0ZQNhXT1LV1xSXTGxCXqaZg00aoZW1N
         4fR8JSbZ5H64OT1hRSmDFArtTJZ757yRodpIPDpPjBLQE8eD3kw7bBmZ9q+p69ORuJHO
         xok69BtrAA58HXci0Ky8kkH9+nlIKrXjgEN5UY9CX7a8fltFUoRl2IaUYiMUcEpdvxoL
         4YhLAkh67yJBsYP9Hrep/yfhjz2hLEYgExAVhM4i5niAPQe0uD1bBetyIl8sWhY1G1Wd
         4z3Q==
X-Gm-Message-State: AOAM5311J56pTQvSJ9s/BQbEKbJ1NibqBUpuPn/IUpik2Bn6S7XwGBT0
        MV/Do2WthEdx3PIVn4RDwYRTe8aAjQEejg==
X-Google-Smtp-Source: ABdhPJwB201iiHpk5+3QL8eVGM7clp0AERsAw7H4ideQyhyMRSxukGJYxwk3RyMAbG2TOvmekK3D4g==
X-Received: by 2002:a05:6214:2505:: with SMTP id gf5mr5909823qvb.55.1637673925554;
        Tue, 23 Nov 2021 05:25:25 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id b2sm5837535qtg.88.2021.11.23.05.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 05:25:24 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mpVnX-0001kU-Up; Tue, 23 Nov 2021 09:25:23 -0400
Date:   Tue, 23 Nov 2021 09:25:23 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     David Hildenbrand <david@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211123132523.GA5112@ziepe.ca>
References: <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
 <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f998bb7-7b5d-9253-2337-b1d9ea59c796@redhat.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 22, 2021 at 09:08:47PM +0100, David Hildenbrand wrote:

> > You can't use mmu notifiers without impacting the fast path. This isn't
> > just about io_uring, there are other users of memlock right now (like
> > bpf) which just makes it even worse.
> 
> 1) Do we have a performance evaluation? Did someone try and come up with
> a conclusion how bad it would be?

It needs additional locking between page readers and the mmu notifier.

One of the virtio things does this thing and they used rcu on the page
readers and a synchronize rcu in a mmu notifier - which I think is
pretty bad.

> 2) Could be provide a mmu variant to ordinary users that's just good
> enough but maybe not as fast as what we have today? And limit
> FOLL_LONGTERM to special, privileged users?

rdma has never been privileged

Jason
