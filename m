Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 679307370ED
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbjFTPuM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 11:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjFTPto (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 11:49:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC4D1BF0
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 08:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1687276164;
        bh=MowjYhMUQyY3zSTDhkuCNdT24j6SlkKM7oL+cuDz4U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=L7f/N1zfzwbHy5yquen3Ihs+Ax6hG/ttHG/PUXFAP76LawCacUTUgYhQXpL+FATQE
         KqFehvhb8ieXf57XshQrAfPX+w8f2lZfplmy12Hg5RSbdAHuVzHhes6vbxj16a0vaf
         kZjXBNtjGJwCMH37nXORm/4KYHOKMu9ug8SrpIf4i1NFL35Fl7qnqDjcJKa0aqx1ep
         yE1qaKrW5OoeBgCEa0/IteknyJOsse9+Fk88iaZN2N6XQEyf3ocfsW0BavTIQUxIhW
         KnLIUYaoHVL2M66JatyICf0AaD0SCNF3l2+kaTqeJG7JOwRU+KmoqRkFK3TVVp8OAb
         yoIggkwVLAGZw==
Received: from biznet-home.integral.gnuweeb.org (unknown [68.183.184.174])
        by gnuweeb.org (Postfix) with ESMTPSA id 0791B249D18;
        Tue, 20 Jun 2023 22:49:21 +0700 (WIB)
Date:   Tue, 20 Jun 2023 22:49:08 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Guillem Jover <guillem@hadrons.org>
Subject: Re: False positives in nolibc check
Message-ID: <ZJHKdAf2tPe+6BS6@biznet-home.integral.gnuweeb.org>
References: <20230620133152.GA2615339@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620133152.GA2615339@fedora>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 20, 2023 at 03:31:52PM +0200, Stefan Hajnoczi wrote:
> This is caused by the stack protector compiler options, which depend on
> the libc __stack_chk_fail_local symbol.

Guillem fixed it last week. Does this commit fix the stack protector
problem? https://github.com/axboe/liburing/commit/319f4be8bd049055c333185928758d0fb445fc43

> In general, I'm concerned that nolibc is fragile because the toolchain
> and libc sometimes have dependencies that are activated by certain
> compiler options. Some users will want libc and others will not. Maybe
> make it an explicit option instead of probing?

I made nolibc always enabled because I don't see the need of using libc
in liburing. If we have a real reason of using libc, maybe adding
'--use-libc' is better than bringing back '--nolibc'. 

I agree with what Alviro said that using stack protector in liburing is
too overkill. That's why I see no reason for the upstream to support it.

Can you mention other dependencies that do need libc? That information
would be useful to consider bringing back libc to liburing.

Regards,
-- 
Ammar Faizi

