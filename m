Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AB74D42B4
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 09:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbiCJIiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 03:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240476AbiCJIh7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 03:37:59 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E87136EE3;
        Thu, 10 Mar 2022 00:36:57 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D4F5768AFE; Thu, 10 Mar 2022 09:36:52 +0100 (CET)
Date:   Thu, 10 Mar 2022 09:36:52 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220310083652.GF26614@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com> <20220308152105.309618-18-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-18-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:51:05PM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> On submission,just fetch the commmand from userspace pointer and reuse
> everything else. On completion, update the result field inside the
> passthru command.

What is that supposed to mean?  What is the reason to do it.  Remember
to always document the why in commit logs.

>  
> +static inline bool is_inline_rw(struct io_uring_cmd *ioucmd, struct nvme_command *cmd)

Overly long line.
