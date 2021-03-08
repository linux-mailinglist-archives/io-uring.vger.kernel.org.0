Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514BB330CBF
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 12:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCHLwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 06:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhCHLwZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 06:52:25 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDD3C06174A;
        Mon,  8 Mar 2021 03:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=czRKeaftASrqoaZ+92Ke1GRtQ0i0HcRE6l6XeTFk4j0=; b=woyKu8ag9LVTEOQ/I/vzcWeRvS
        25LRKDFA1jR44SuNNJ2aoHb38QKJ4GG7NF7HuvmJBZBMvTEm4eTenMD2PHt0pQFuKIK5pQApIMw6h
        2+1/Yt5ZqZHg5pj3FeWqEG3EuEwFz7I3KlqKJDqK0wKste47YTLCmRr2cLAvrUVHPjwLaOU1VGFT0
        bGQIX9B95PQwyjuFVWzOEZQHOML9HtrOr17tYwlZ4mFj5T41Ju71UR/yl6/ONOwF6qDStQEVDXdmi
        DVP7XvegL1cOhl+1XfwQgKactRUaHhLP2pVYonF2Ss/zi496DkslUkZPAdXqs4MDCR2HCX1LWBKB3
        Cn9L1AaG+/rZzfB2iK+uYlRR4PRD2ESbmnkJ9BuE6fC5z+AFAWgsZt+0neD/xg7Y56BXyQoxGBA92
        9Mu7fbC+8qFBNVCQbqwgP8sDzAKQmtuaUtHscrNYdtYNsdn9eZV4IBEeEx7jiHrVZ0FQQ+zyXIgm8
        gzyoNyqBmC10+GsRllu3dL+0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lJEQp-0000cn-Kq; Mon, 08 Mar 2021 11:52:15 +0000
Subject: Re: [RFC PATCH v2 00/13] Add futex2 syscall
To:     Daurnimator <quae@daurnimator.com>
Cc:     =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel@collabora.com, krisman@collabora.com,
        pgriffais@valvesoftware.com, z.figura12@gmail.com,
        joel@joelfernandes.org, malteskarupke@fastmail.fm,
        linux-api@vger.kernel.org, Florian Weimer <fweimer@redhat.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>, corbet@lwn.net,
        io-uring <io-uring@vger.kernel.org>
References: <20210304004219.134051-1-andrealmeid@collabora.com>
 <ecbed98e-882a-0c0e-d4e1-bd33960f3674@samba.org>
 <CAEnbY+e0=4B4SwgspdhYePg7gdMdKj=Xgu=8k0zVKX-SKfy24A@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <c565f06d-8987-2117-589a-0c78ff6b4d47@samba.org>
Date:   Mon, 8 Mar 2021 12:52:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAEnbY+e0=4B4SwgspdhYePg7gdMdKj=Xgu=8k0zVKX-SKfy24A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 07.03.21 um 12:56 schrieb Daurnimator:
> On Sun, 7 Mar 2021 at 22:35, Stefan Metzmacher <metze@samba.org> wrote:
>> Instead of having a blocked futex_waitv() waiting on an fd (maybe a generic eventfd() or a new futex2fd())
>> would be a better interface?
> 
> Like bring back FUTEX_FD? (which was removed back in 2.6.25)

Ah, ok, yes something like that.

But as that was removed because of races, but might not be a good idea to bring it back.

metze
