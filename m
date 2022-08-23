Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CC759D191
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 08:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240214AbiHWGxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 02:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiHWGxy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 02:53:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680DC18B11;
        Mon, 22 Aug 2022 23:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 200F6B8105C;
        Tue, 23 Aug 2022 06:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58C28C433D6;
        Tue, 23 Aug 2022 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661237630;
        bh=3p5RO/d+YaKvDjZKTaaaPL6edKKWnGxanIMGu9dxM/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xNz0IuK+mFR7ooTljoAp9juIo1BNq+m1bt1PNOvhctWgxBaJ2r0eT/vwMou/4T/oc
         68vRccpbqn3r19PshIAOCV4voFjn6+XfoC8rSfGrKUNqJy/7fRY0+j+1k5z91aLdOb
         WybYZ5fPCrZzgxcyjRnhqdp1KmMepZOXGCuXgkLA=
Date:   Tue, 23 Aug 2022 08:53:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        io-uring@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH 1/3] lsm,io_uring: add LSM hooks for the new uring_cmd
 file op
Message-ID: <YwR5fDR0Whp0W3sG@kroah.com>
References: <166120321387.369593.7400426327771894334.stgit@olly>
 <166120326788.369593.18304806499678048620.stgit@olly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166120326788.369593.18304806499678048620.stgit@olly>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 22, 2022 at 05:21:07PM -0400, Paul Moore wrote:
> From: Luis Chamberlain <mcgrof@kernel.org>
> 
> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd"), this extended the struct
> file_operations to allow a new command which each subsystem can use
> to enable command passthrough. Add an LSM specific for the command
> passthrough which enables LSMs to inspect the command details.
> 
> This was discussed long ago without no clear pointer for something
> conclusive, so this enables LSMs to at least reject this new file
> operation.
> 
> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com
> 
> Fixes: ee692a21e9bf ("fs,io_uring: add infrastructure for uring-cmd")

You are not "fixing" anything, you are adding new functionality.
Careful with using "Fixes:" for something like this, you will trigger
the bug-detection scripts and have to fend off stable bot emails for a
long time for stuff that should not be backported to stable trees.

thanks,

greg k-h
