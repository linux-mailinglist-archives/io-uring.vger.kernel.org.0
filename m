Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C581206B4C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 06:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgFXEiV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 00:38:21 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36036 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgFXEiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 00:38:20 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AAF3E5AAC64;
        Wed, 24 Jun 2020 14:38:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnxAs-0002xD-OJ; Wed, 24 Jun 2020 14:38:14 +1000
Date:   Wed, 24 Jun 2020 14:38:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 05/15] mm: allow read-ahead with IOCB_NOWAIT set
Message-ID: <20200624043814.GC5369@dread.disaster.area>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-6-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618144355.17324-6-axboe@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=ufHFDILaAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=WCjB2_pVjg0caHknj34A:9 a=CjuIK1q_8ugA:10
        a=3K7KkRBBR4UA:10 a=ZmIg1sZ3JBWsdXgziEIF:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 18, 2020 at 08:43:45AM -0600, Jens Axboe wrote:
> The read-ahead shouldn't block, so allow it to be done even if
> IOCB_NOWAIT is set in the kiocb.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

BTW, Jens, in case nobody had mentioned it, the Reply-To field for
the patches in this patchset is screwed up:

| Reply-To: Add@vger.kernel.org, support@vger.kernel.org, for@vger.kernel.org,
|         async@vger.kernel.org, buffered@vger.kernel.org,
| 	        reads@vger.kernel.org

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
