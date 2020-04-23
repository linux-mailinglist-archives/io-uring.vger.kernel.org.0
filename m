Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8781B5EC6
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 17:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgDWPMW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 11:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729050AbgDWPMW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 11:12:22 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6015C08E934
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:12:21 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y4so6593448ljn.7
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 08:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uFkjtsXusSVZ3BnxCVv2xfvFj2lCfqA+hn/FYp4L7M0=;
        b=ozsfcgFHEJR+Q8/DtA/WlQaS9YiWOPwJCHkKI9NOsUKG3BagUXqXFGPZ6beWcGw3QG
         QjF5Wh5edbmjLUZ9aSRvRAAmVI5gOE4sGo2vTnMCDWmC5mazCKrF+hzhzcGyFNT9qgDH
         JM27ZTu2S+2A/Oc41KrGt1d4TLnrgr7ePQnA9ss38ibRNrXag+DjEwB6pSc+E5Dn1vj9
         0y7gvG0HwFbP6BMYAZhC/xRvvAGJ+pWYATCB5QGRy6i8mL9Uh/Z8oDalDgWh7etSJo+d
         z/agUEnKTMCnaXKylkme0cuKIgcouily1K9AXjgASMtmANrlbvsBWZjRjV719wk5Why6
         yQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uFkjtsXusSVZ3BnxCVv2xfvFj2lCfqA+hn/FYp4L7M0=;
        b=AYsK89rkKAR4wk4I1EC0blfnwakKTXTC8B/NEuY/NUadYiMfF/hcgO04gJJY0bnzmz
         wNAZKwpqMAlBY7cjOE2qXKaxaDC9KnQ8NOz4TO/KmdGdkIoUpuF03U8yI7F17D04Nt2Q
         vTeDqudus2WRqHOjRCu5q0yeXcZ9bRhk278kGVl5om4MShe1QZCyD3ITr0OnTfyVMnuY
         hNBaPvElLF8DJerXCA6OuXMcIKUDVZtTy3G9+nlP8+d9fOr0ui8tK/U/LyL6X8js+BMT
         wNhTKJB2Oe14efut6G0kSyci0R671XYuG3wWCdOr2oR29FDaKgX3Q5Q+4POr+M6WCy4B
         dStA==
X-Gm-Message-State: AGi0Publt8k8JBL2hHBgYBwngXhb+QdFa1DwbrjOVGb1oc5Y2c6PNmmD
        IqZOarrNTB90ISe0fvLRR6nswb4TjYL4VXLuoX8Szyi+
X-Google-Smtp-Source: APiQypLFIRY8+6W4utibUSifz+8o9m8JDK5DoQV3vmEkoqCjGBCUHKdzNi7+OstPuR3O8tfKyENpIX7B33dpVAcULCU=
X-Received: by 2002:a2e:b4f1:: with SMTP id s17mr2612360ljm.283.1587654740343;
 Thu, 23 Apr 2020 08:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200420162748.GA43918@dontpanic> <2e16eecf-9866-9730-ee06-c7d38ac85aa4@kernel.dk>
 <CAJ75kXY1VLoqab4quz8RykbFrbXNJVBSAf7jv4t+u0_OquE1cQ@mail.gmail.com> <fc04aedf-a417-de72-9ee4-6aa1dbf18226@kernel.dk>
In-Reply-To: <fc04aedf-a417-de72-9ee4-6aa1dbf18226@kernel.dk>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Thu, 23 Apr 2020 17:12:08 +0200
Message-ID: <CAJ75kXbE62-TCcZKkk2boCWTdgA4Zj6wmY+zyBjEKQx1AQnwgg@mail.gmail.com>
Subject: Re: io_uring_peek_cqe and EAGAIN
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 23, 2020 at 5:05 PM Jens Axboe <axboe@kernel.dk> wrote:
> Ah ok, yes that sounds like a misunderstanding. Events are posted as
> they become available, availability of one does not mean that everything
> has completed.

Indeed, now that I understood my mistake everything is crystal clear.
Thanks a lot for the clarification!

-- 
William
