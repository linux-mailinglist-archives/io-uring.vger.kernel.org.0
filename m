Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F89546623
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 13:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347707AbiFJL4N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 07:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347368AbiFJL4E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 07:56:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B3B00;
        Fri, 10 Jun 2022 04:56:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FE5862154;
        Fri, 10 Jun 2022 11:56:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A06C34114;
        Fri, 10 Jun 2022 11:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654862162;
        bh=Jb+E53UK3K0UvEjJa7PhN5boXbzR4B95dLbvEMAmnTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eveBqnTI2Mn7VOndm1X7Vt3mhzwknp+GtXZ6UVIqIzqwaPzR5VRH/DZ9C/agTpTbu
         UjNO1YDOuxMPXlSuWBDjlvUnV/tSg5lZe1miyH3DD04CO4sxjKjZCnfPLJkU2FM7XH
         +gYm03BLoGcGm1hKp4x9o6fVPANREk9Rfb1o1lXpYu0vC1uTCI8O7+HJb6BWRkojoW
         Polxv89qWlg6+6TTfQu1wkPN7joMguPI1iZ09GuqhHKU9JQdPLaelWoXzCxU5GXTqt
         rdgmQCGwHvvzpCCzC6E82Y6PlVaS6NSctO6gCj3+g1b2h+4Ccr22kx9mp49VlE12r0
         AxI/vT8iOWHcQ==
Date:   Fri, 10 Jun 2022 13:55:51 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v8 09/14] fs: Split off inode_needs_update_time and
 __file_update_time
Message-ID: <20220610115551.4i2dquycjjirpwne@wittgenstein>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-10-shr@fb.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:36AM -0700, Stefan Roesch wrote:
> This splits off the functions inode_needs_update_time() and
> __file_update_time() from the function file_update_time().
> 
> This is required to support async buffered writes.
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me now,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
