Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139A44595DE
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 21:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhKVUG4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 15:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhKVUGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 15:06:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64893C061574;
        Mon, 22 Nov 2021 12:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vvLpdHaUFHt3N4gXjtu6QffcwbzuOaP9bKHqPEhJSIU=; b=NSPF2sIpkdz+XiHcIyNY0ST1Jv
        K2ZNfT306Fy+mxo/Gf2WkwXBKzfrj0dQGgzpV5DJ1nlp+G1p1Ox/c280f/EWTNqP2BOwIQ93Nb4Q+
        oTijhwzjuaQcQkzzlQJMnyIrHpDS2zBSohyuHeuRb+KIPlkvdnrdKlHb+bKYtXWSbeTV+cwLYjR8M
        oWO7W7vsAzy2ZRIUKlI4m4U89oMomMTLskgyvQCWpdOwan2Perc3bQrRuDO1Eq7f+546jmLP0Z+4f
        VzWfhzURZhSpJA6Db/7pK9oKljfOuDn3scDi+bYonCk1EooQVblVUABFlXF/po/0GLsy4OmHb93aL
        cEOBoYTg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mpFXG-00D8NV-R5; Mon, 22 Nov 2021 20:03:30 +0000
Date:   Mon, 22 Nov 2021 20:03:30 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Dona-Couch <andrew@donacou.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Drew DeVault <sir@cmpwn.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <YZv3khUomkmRh/X6@casper.infradead.org>
References: <593aea3b-e4a4-65ce-0eda-cb3885ff81cd@gnuweeb.org>
 <20211115203530.62ff33fdae14927b48ef6e5f@linux-foundation.org>
 <CFQZSHV700KV.18Y62SACP8KOO@taiga>
 <20211116114727.601021d0763be1f1efe2a6f9@linux-foundation.org>
 <CFRGQ58D9IFX.PEH1JI9FGHV4@taiga>
 <20211116133750.0f625f73a1e4843daf13b8f7@linux-foundation.org>
 <b84bc345-d4ea-96de-0076-12ff245c5e29@redhat.com>
 <8f219a64-a39f-45f0-a7ad-708a33888a3b@www.fastmail.com>
 <333cb52b-5b02-648e-af7a-090e23261801@redhat.com>
 <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca96bb88-295c-ccad-ed2f-abc585cb4904@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 22, 2021 at 12:53:31PM -0700, Jens Axboe wrote:
> We should just make this 0.1% of RAM (min(0.1% ram, 64KB)) or something
> like what was suggested, if that will help move things forward. IMHO the
> 32MB machine is mostly a theoretical case, but whatever .

I think you mean max(0.1% ram, 64KB).  with that change, I agree.
