Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6434C1A6519
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 12:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgDMKUG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 06:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728185AbgDMKT5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 06:19:57 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD93C0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 03:19:54 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id i14so7999654ilr.11
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 03:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=apNIXe4DDULaBM5ysKbAT70aKHGKLTZULPp1fM098Nw=;
        b=GVEmyrLs9NwnrurcOmlmuuYORHNe2VWIerifTLo5MBgQQSTpzeI9NM83gvKBlL0bvu
         bNfzjCxoVjERG1VVxeG1dpJ8UNTkIYxtq5QJ+eHxd9CIydhD82UAaKO6OeqrKTK3voz3
         /jiTKSGyyaj8nK8HozFNAapoDFgUi5rJO4QlD8vaAqk5XIEdqnRLLOBFR+k3uXRjeAvP
         BcyLo8zfi37ZeXUG5HXXQu+WtVeOInMGhbiDhc8HcMWmF35ANOWDIiKzKWFIPAmTZw3h
         D4eparIeLwYfFOCkF7EHpmjCYT9ElQ/8xr1cIPuCCP/Km2YAiLMjPNnHPxM7kqn5lsyV
         VIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=apNIXe4DDULaBM5ysKbAT70aKHGKLTZULPp1fM098Nw=;
        b=H/5YpYZM1d0Qy0A1wUGRabnAkcIkT9/S90W8anXaxhBkMTkOi8xK1IeoSUXuYaZCUG
         IMpYIjWaz8gaVgFKxxn7gkxAP6uzn0k4n/zlsmNO9+G5+Ol199KtFkvuJRidXpFbHISH
         OaZtqjcO8pOK5yn/FEKZOpJgUKvvGUIoGwwJcklPtD3UWisH5rAGJs/lgPueq5qNPDQy
         mFabcEdK/iAOIJVR23q5i6/980qK1F/LA0YhHxAxVCWdaCoza0lig7fFvOi3ZsE8O1CK
         jGth7W5guKaF7pn9HXukYa3ZMr/l6kTqHQEy4zI8pq4bxMqOtoHeskzTdhcvdIFh+qSG
         kR6g==
X-Gm-Message-State: AGi0PubC50FAoUH5bbp2E2Q8M+mq/VdAhu9beWnEd/1oT1Qz/TJO4Dmm
        ndVEm3lGpBaj6V4K033rqg83wFGfPMJjFQHGX7g=
X-Google-Smtp-Source: APiQypJjTuu7VireQTtaNcmtmmF5szEFutWTNUlRFe5p//ABWXacKYtlxduLI6Gc40Nrz/7wLyjlarxb0KjBRnetTC0=
X-Received: by 2002:a92:cbd1:: with SMTP id s17mr14872757ilq.154.1586773193738;
 Mon, 13 Apr 2020 03:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAOKbgA4K4FzxTEoHHYcoOAe6oNwFvGbzcfch2sDmicJvf3Ydwg@mail.gmail.com>
 <3a70c47f-d017-9f11-a41b-fa351e3906dc@kernel.dk> <CAOKbgA7Pf2K5o_CkAs2ShcNbV8dx75xZBfM8D1xZcLm5RjmLXA@mail.gmail.com>
 <cc076d44-8cd0-1f19-2e79-45d2f0c5ace3@kernel.dk> <CAOKbgA4xX60X+SCMZFL76u86Nyi0Gfe25BGJaqR700+-zw72Xw@mail.gmail.com>
 <47ce7e4b-42d9-326d-f15e-8273a7edda7a@kernel.dk> <CAOKbgA5BKLNMzam+tDCTames0=LwJmSX-_s=dwceAq-kcvwF6g@mail.gmail.com>
 <7e3a9783-c124-4672-aab1-6ae7ce409887@kernel.dk> <CAOKbgA7KYWE485vAY2iLOjb4Ve-yLCTsTADqce-77a0CQxnszg@mail.gmail.com>
 <d55af7f3-711b-23b9-2ea3-00d600731453@kernel.dk> <CAOKbgA6JN4oQzyUo0_2y2KUKGX_xuwmDnQsCCABPq_nxms12Aw@mail.gmail.com>
 <bba27d9d-db8c-f916-5f56-5583ba56591b@gmail.com>
In-Reply-To: <bba27d9d-db8c-f916-5f56-5583ba56591b@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 13 Apr 2020 17:19:40 +0700
Message-ID: <CAOKbgA5JcPZ4tWyXORHLfmCYZerUJo6PASKx3YRrbeH67GDa=w@mail.gmail.com>
Subject: Re: io_uring's openat doesn't work with large (2G+) files
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 13, 2020 at 5:09 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 4/13/2020 12:20 PM, Dmitry Kadashev wrote> Can I ask if this is going
> to be merged into 5.6? Since it's a bug
> > (important enough from my perspective) in existing logic. Thanks.
>
> Yes, it's marked for 5.6

Perfect, thanks!

-- 
Dmitry
