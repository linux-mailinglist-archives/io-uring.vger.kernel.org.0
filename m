Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32D58F231
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiHJSOw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 14:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHJSOv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 14:14:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB9275389;
        Wed, 10 Aug 2022 11:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wdyptz8v1uMMnY9kHa999mGXzTZq4vrNBD6JJO975pY=; b=xQFEJRje+5KYZsm78qd561Znmf
        3i3ixO5ZS9RypJYMDJuHQ/VVnpJ5ey3altYugRYiy3drQQ8N8HWCpLpIYWlbqfVzPd17sMCFv8Wwo
        izZECbe0a8Jql4C6P94qRJdH8aY8N50tF0PrsS3hEH0yraNcuryt6RA7MIrca9sLI6bBNLHri/ct+
        hD/fsxAykUqXjtMYm7VZaDWQ4cLkVx46dpxm6MFZVzdxi7+jwbFNo7V4A92mrI60xAa/OVKRt9EIC
        6P0AKidp0kYcs/a41sR1v+oma/Psnh5Y+5+x3BmIcUuS1ji2YRWet1IOUaTKtvIIqlC5nj2vjjyys
        wMWXbB2A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oLqE0-00De0o-Nx; Wed, 10 Aug 2022 18:14:36 +0000
Date:   Wed, 10 Aug 2022 11:14:36 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        casey@schaufler-ca.com, paul@paul-moore.com, joshi.k@samsung.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Subject: Re: [PATCH v2] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
Message-ID: <YvP1jK/J4m8TE8BZ@bombadil.infradead.org>
References: <20220715191622.2310436-1-mcgrof@kernel.org>
 <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a56d191e-a3a3-76b9-6ca3-782803d2600c@kernel.dk>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 15, 2022 at 01:28:35PM -0600, Jens Axboe wrote:
> On 7/15/22 1:16 PM, Luis Chamberlain wrote:
> > io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> > add infrastructure for uring-cmd"), this extended the struct
> > file_operations to allow a new command which each subsystem can use
> > to enable command passthrough. Add an LSM specific for the command
> > passthrough which enables LSMs to inspect the command details.
> > 
> > This was discussed long ago without no clear pointer for something
> > conclusive, so this enables LSMs to at least reject this new file
> > operation.
> 
> From an io_uring perspective, this looks fine to me. It may be easier if
> I take this through my tree due to the moving of the files, or the
> security side can do it but it'd have to then wait for merge window (and
> post io_uring branch merge) to do so. Just let me know. If done outside
> of my tree, feel free to add:
> 
> Acked-by: Jens Axboe <axboe@kernel.dk>

Paul, Casey, Jens,

should this be picked up now that we're one week into the merge window?

  Luis
