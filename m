Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A298558240E
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 12:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiG0KUf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 06:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiG0KUe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 06:20:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3953342ADA
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:20:33 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id f8so408779ils.13
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 03:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=DLhgp+dbjRPHZGeDmNIE7zMTp+13s6oFE73dzTrctv8=;
        b=LQ0Ouvdko0LvLs7zj40If8t+0ZRgXNsf//OVPhZWaVoEIbUos5gkZSsrPk+8sy0PFZ
         dAJs1PeaTw2yYG/blpcYK7rzvMxC2PpvnodBPBNnC4Pg+DzFtbxlcCDq8zCYe3zNZ7Gj
         Wna5F2ioUOKSZ2PCLjmPXrWEFRIeX+g580sl52xIcleHd591MjPbJAH71SIc5f7CkfbY
         W4DnvzieesvF9tpGsDCX6iZfgt9b3aLkuPRNtoFYeQ11Tq8ctBU+fE9RyaYhyowcEHHN
         J1xussZVLyddh+oymYG6jU85FCS6cFW1+8A/0zA7y1NHUF4PMCCD1PQtSfdICloJKyRE
         gLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=DLhgp+dbjRPHZGeDmNIE7zMTp+13s6oFE73dzTrctv8=;
        b=fUJmdHXng4wYQ1xvqUL9Dkd595sNJ6xXQW7T7zZTwRC7yb3PMjzoHU4mo3JzuHu9yA
         F4t0uDCR5Ro2DjhQtWPOEYTpEUwLtwZyMpMRjvwPq6q9idF/8inCYIL2j7xdBRznWck8
         8DuH5N4rczMkXbwDJlLbnUwi3KQkkTaXxHXnm9pNkq0iKB0kWwjghnWK/i0iOPEKUOIb
         sz0PWi+PwpydozKi6g5S2wyOcLnhWaDU0YEaYp8V7zxj0TvZLLJYwvLC51Y3o/QYu6h7
         MFNg7Cg+ZECJge0RRbeyYeVR29GX0Nfslsb0HiVNlYwW5/2EuwFToU+jS50AEblmZQn6
         V4dA==
X-Gm-Message-State: AJIora++xWLn97Y48M49lhdD/DhDAv1Ij45i5NcoU+yeJWp4x+HQUy5k
        IcIoKpXwJ2xb5FOVACmbGyqb06T66dvNhI5R+zwQhbPSUPE=
X-Google-Smtp-Source: AGRyM1sviIlcmtRoHisZg/Q6ro/3Dj0ncRpY1lQTefhLQrpV1804wVJWm52SxSJIJld24Q9QQHmCCFISka1uBVKxS2A=
X-Received: by 2002:a05:6e02:1a0d:b0:2dd:435a:7b89 with SMTP id
 s13-20020a056e021a0d00b002dd435a7b89mr6518127ild.274.1658917232561; Wed, 27
 Jul 2022 03:20:32 -0700 (PDT)
MIME-Version: 1.0
From:   Bikal Gurung <gbikal@gmail.com>
Date:   Wed, 27 Jul 2022 11:20:20 +0100
Message-ID: <CA+v7nzg1O_nw6yicX9uVs7BpaovH7Z0hNgqzKrRLP-_m3XA-_g@mail.gmail.com>
Subject: Confused about count argument in io_uring_prep_timeout
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

I am trying to understand the 'count' argument in liburing
io_uring_prep_timeout call. Does this argument signify the number of
cqes after which the timeout value 'ts' becomes armed?
