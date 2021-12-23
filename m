Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA3447E1B9
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 11:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347783AbhLWKsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 05:48:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49644 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347769AbhLWKsQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 05:48:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A406BB81F72;
        Thu, 23 Dec 2021 10:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0ADC36AE9;
        Thu, 23 Dec 2021 10:48:12 +0000 (UTC)
Date:   Thu, 23 Dec 2021 11:48:09 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, torvalds@linux-foundation.org
Subject: Re: [PATCH v6 1/5] fs: split off do_user_path_at_empty from
 user_path_at_empty()
Message-ID: <20211223104809.4k3ukcqhxmnzzmsu@wittgenstein>
References: <20211222210127.958902-1-shr@fb.com>
 <20211222210127.958902-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211222210127.958902-2-shr@fb.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 22, 2021 at 01:01:23PM -0800, Stefan Roesch wrote:
> This splits off a do_user_path_at_empty function from the
> user_path_at_empty_function. This is required so it can be
> called from io_uring.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---

(Not excited we're continuing exposing two variants one with char *name
and struct filename *filename but we've done it for the mkdir/mknod etc
series already. But we should earmark this for something that we might
look into doing better in the near future.)

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
