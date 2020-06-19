Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236EF200787
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 13:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbgFSLMF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 07:12:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:47314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732583AbgFSLMB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 19 Jun 2020 07:12:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1966DADAA;
        Fri, 19 Jun 2020 11:11:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2EB06DA9B9; Fri, 19 Jun 2020 13:11:11 +0200 (CEST)
Date:   Fri, 19 Jun 2020 13:11:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Jens Axboe <axboe@kernel.dk>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 12/15] btrfs: flag files as supporting buffered async
 reads
Message-ID: <20200619111110.GC27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, Chris Mason <clm@fb.com>
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-13-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618144355.17324-13-axboe@kernel.dk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 18, 2020 at 08:43:52AM -0600, Jens Axboe wrote:
> btrfs uses generic_file_read_iter(), which already supports this.
> 
> Acked-by: Chris Mason <clm@fb.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Can you please CC the mailinglist for btrfs patches? Thanks.
