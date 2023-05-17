Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F757706A39
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 15:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjEQNxt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 09:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjEQNxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 09:53:48 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCB098;
        Wed, 17 May 2023 06:53:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2EF0968BEB; Wed, 17 May 2023 15:53:44 +0200 (CEST)
Date:   Wed, 17 May 2023 15:53:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, kbusch@kernel.org, sagi@grimberg.me,
        joshi.k@samsung.com
Subject: Re: [PATCH for-next 2/2] nvme: optimise io_uring passthrough
 completion
Message-ID: <20230517135344.GA26147@lst.de>
References: <cover.1684154817.git.asml.silence@gmail.com> <ecdfacd0967a22d88b7779e2efd09e040825d0f8.1684154817.git.asml.silence@gmail.com> <20230517072314.GC27026@lst.de> <9367cc09-c8b4-a56c-a61a-d2c776c05a1c@gmail.com> <20230517123921.GA19835@lst.de> <61787b53-3c16-8cdb-eaad-6c724315435b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61787b53-3c16-8cdb-eaad-6c724315435b@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 17, 2023 at 02:30:47PM +0100, Pavel Begunkov wrote:
> Aside that you decided to ignore the third point, that's a
> generic interface, not nvme specific, there are patches for
> net cmds, someone even tried to use it for drm. How do you
> think new users are supposed to appear if the only helper
> doing the job can hang the userspace for their use case?
> Well, then maybe it'll remain nvme/ublk specific with such
> an approach.

New users can add new code when it's actualy needed.  We don't
bloat the kernel for maybe in the future crap as a policy.
