Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85CE24557B
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 04:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbgHPCjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 22:39:32 -0400
Received: from mail.cmpwn.com ([45.56.77.53]:57588 "EHLO mail.cmpwn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgHPCjc (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 15 Aug 2020 22:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cmpwn.com; s=cmpwn;
        t=1597545571; bh=VS+cpXcug8bv/YxDZQZQkiS0W6liB9vfOXJ0WqjAo/8=;
        h=Subject:From:To:Date:In-Reply-To;
        b=Y0MDx67FC09bQ6IN62dYGqMoW6g/YUBIS6oWZpmC4g8gNDLu6ivB5iLa85TDLngTh
         6vCM9Wt3PPEt854JArhXTvypoLKVCJigvPmDed4JjNpWvEvHB9FHW/BFWOJkvcc1F5
         A9//Z5DvTGYZdw9dZCEWM1R88wzHijYJj77E+UlU=
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: Consistently reproducible deadlock with simple io_uring program
From:   "Drew DeVault" <sir@cmpwn.com>
To:     "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>
Date:   Sat, 15 Aug 2020 22:38:00 -0400
Message-Id: <C4Y2LXWFIUZX.47V7HCX3WU5D@homura>
In-Reply-To: <839f2d17-0486-b12d-3540-4a8408902492@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat Aug 15, 2020 at 10:37 PM EDT, Jens Axboe wrote:
> This should be fixed by this one:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=3Dio_uring-5.9&id=3Dd4e7=
cd36a90e38e0276d6ce0c20f5ccef17ec38c
>
> which will go into 5.7/5.8 stable shortly. Affected files are the ones
> that use double waitqueues at the same time for polling, which are
> mostly just tty...

Thanks, I'll give this patch a try. I can trivially verify that it works
correctly if stdin is not a TTY, I should have tried that myself. Do you
know of any userspace workarounds for the problem that I could try on
older kernels?
