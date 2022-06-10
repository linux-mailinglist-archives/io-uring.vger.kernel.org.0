Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495F9546617
	for <lists+io-uring@lfdr.de>; Fri, 10 Jun 2022 13:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbiFJLxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jun 2022 07:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346810AbiFJLxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jun 2022 07:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE3D1F62E5;
        Fri, 10 Jun 2022 04:53:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF95BB834C6;
        Fri, 10 Jun 2022 11:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1414EC34114;
        Fri, 10 Jun 2022 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654861985;
        bh=mcJoaA7MH6ch29GuoCXyJ0WlsPi4pa9FoF3KjsefYpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vOxc6bYO8fDsI+3Ga5tOPa3gOQb+BMqG0OJWXfNl5Pb1cCZbdNtUwkvZaC30gOB0t
         M9qF/T06frXeTs3s0o77ITQ+k+pX2sfQrkQfvPGS3cn9fFBmQvFn5yCmq37diU2etl
         vqRfVyK3y2b+Qs3FqySuodRYpyNypZcsAiiD++Ab1fMREelciJwPJOshjrsiUcycY+
         bDpWHStLbIIkNw+clHPSkYpvz3lwN9e5MVR9o6xmMV7dl8qpFEgQ2eZq0KMGh9vL/j
         DHwaYIfzK1nrPn9BEhb4BsPipShQgmFWquWwzbRQ0fOK2j5PdMEDlQ74lY28YHSrIW
         zZF7yPjCFhxaA==
Date:   Fri, 10 Jun 2022 13:53:00 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 08/14] fs: add __remove_file_privs() with flags
 parameter
Message-ID: <20220610115300.ph52f773eqqi24s5@wittgenstein>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-9-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-9-shr@fb.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:35AM -0700, Stefan Roesch wrote:
> This adds the function __remove_file_privs, which allows the caller to
> pass the kiocb flags parameter.
> 
> No intended functional changes in this patch.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
