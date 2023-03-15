Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C096BAAB0
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 09:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCOIXj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 04:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCOIXg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 04:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B040132FD;
        Wed, 15 Mar 2023 01:23:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6346B81D89;
        Wed, 15 Mar 2023 08:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02207C4339B;
        Wed, 15 Mar 2023 08:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868611;
        bh=B71tmuXoKUraNIbAlW4T8OPjG2x0A6vNvLJvCKB5GUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EgBWo8bJI6LVUXhHMGXjR7iMPt5vO3yS6TEytD9I/UbIN+NYCBIFVDYw8FspOsp0h
         rFGsNAbqbbZQihfe916TkFxppd+2lM7BLwDq8MCQcFJWYRrI3ePgaFl+YeV3bePecr
         jStDEisfqq0Bpdywca/CFLqleu5IQqYb7IVI/pGxPl9a2D+0KC5JWDhyyKXr0UbcDs
         OxKSkCeKO2q8SLAVGqplDX4CvZTHlXu6ov/szmaIBW3V26xX7OLtNyHqySQZ8FE7Q4
         z+iNMjayK7pCsUx9k3n2y4s5PzQlvHI8WU/uiewE2S8ttemL9ywQZ1K0EvAB5ZETux
         FqK85hCAO64ug==
Date:   Wed, 15 Mar 2023 09:23:21 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Message-ID: <20230315082321.47mw5essznhejv7z@wittgenstein>
References: <20230314154203.181070-1-axboe@kernel.dk>
 <20230314154203.181070-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230314154203.181070-3-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 14, 2023 at 09:42:02AM -0600, Jens Axboe wrote:
> In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
> and write path handle it correctly. This includes the pipe locking,
> page allocation for writes, and confirming pipe buffers.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Looks good,
Reviewed-by: Christian Brauner <brauner@kernel.org>
