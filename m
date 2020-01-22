Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258A3145B59
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 19:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgAVSJE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 13:09:04 -0500
Received: from mail-qv1-f53.google.com ([209.85.219.53]:39265 "EHLO
        mail-qv1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVSJE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 13:09:04 -0500
Received: by mail-qv1-f53.google.com with SMTP id y8so190133qvk.6
        for <io-uring@vger.kernel.org>; Wed, 22 Jan 2020 10:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=DEKx1BJ8CumYXHlC077b8dw7JE24M62V5zX3VX1ojVA=;
        b=FRnVa2AyYYtYBDZ3aRHD/hgJXvM31n9+4AyEwyDSWZmN7aiMEfu98cXLRMvUnwAcoN
         35OxoOAWfMBHh/c0jcTCcsI/w6dJaP8jgUs79w29+wUd+fPcLELVEhAZnypZLVP4tOzI
         WvD3DAXsSr0cQobNe4K8hIeyl3tcTBB7LxmIrwSgWQ1cgJccuQ60nVqNGu8Eea94tdwq
         f8HpXQ35utnPK2TreglVxqbP++XTbEMXxZFFkFaVap7AYLZXiJEdE6iqsw3wYmZJNyqN
         +Cf183VhKfgXKn8KUbkCYMymPQPXRq6vCUYarMSDYSjy49OexxBTmdDmgqYNM2yW5FGI
         M30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DEKx1BJ8CumYXHlC077b8dw7JE24M62V5zX3VX1ojVA=;
        b=Xsc459mzjHQ/YpqofLlDpOFXqGsMivovWx0yIox2fJiSOdtDNCLwwGW4YETMkxldMu
         L1rFnuUTXh6SwESDvUD247pvMlDkm08igb1WIEu2cX7dFN2XRFq2VcIJMmMecWMgD7+1
         qoz7fPsHEwtVnlu2rNcxduwfqffUrqRimLqjgowinpUjvE6oZau5Yp3Y6HXP/tHGxPfx
         FpyagPsYYrjBFzpozogjZMNrYdQyZzKIqmFkLqinES2XT4RhZQ0gwGIiJeiCtsxz+zRe
         oFqd812O8ce90ok0KNkaTHIFGKdfHXW0nOmeVSKrJQb77jydXwYwGJLKR4J3Z5wvI8JA
         d6SA==
X-Gm-Message-State: APjAAAXFF0wNoqTwlOK5vt8rLDu1VrWGCGB4Okbqr9Vkxx0995dceGxq
        rIT0E2eDEAigp49N9Ob3ajywGuVJiB2o/e4iSYPUcdpNa0GAy04=
X-Google-Smtp-Source: APXvYqzye7i5wyBFfNFjFOlSY/B5rHqcJ4BBDR7tx4zO7JwKr5CbdnqZ8Ne4JsSRBoIdHdjApCNuvv8lP1kWms8n9vY=
X-Received: by 2002:a05:6214:13ef:: with SMTP id ch15mr11936092qvb.183.1579716543506;
 Wed, 22 Jan 2020 10:09:03 -0800 (PST)
MIME-Version: 1.0
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 22 Jan 2020 21:08:32 +0300
Message-ID: <CADPKF+cOiZ9ydRVzpj1GN4amjzoyH1Y_NRA7PZ4CLPpb-FrYfQ@mail.gmail.com>
Subject: First kernel version with uring sockets support
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's unclear starting from what version the kernel and headers
were updated with sockets support(IORING_OP_ACCEPT etc).

I just checked today 2020/01/22 Focal Rossa Ubuntu and the last OP is
only IORING_OP_TIMEOUT (still on kernel 5.4.0-12) ;(

So maybe it's a good idea to comment-update every io_uring.h OP with
minimum kernel version requirement...

p.s. Not every Linux user is a kernel hacker ;)
