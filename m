Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4423F30C60E
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 17:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhBBQhr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Feb 2021 11:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbhBBQfR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Feb 2021 11:35:17 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891A8C0613D6
        for <io-uring@vger.kernel.org>; Tue,  2 Feb 2021 08:30:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a9so12524171ejr.2
        for <io-uring@vger.kernel.org>; Tue, 02 Feb 2021 08:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gq1+JtZqe+OdhKHQhHmWczD+AIQ00/IVZauq36LAU1A=;
        b=m3Z93dqY+SiPeBEYs35+VfhFvX84BAj2WhzuBOjMVw05FQNw9RTxBPuYJefaRZERrr
         NJfab8mRIFGm5tEpIHgoaEXmn6O/Q608rpBB+E7UvRvt8Ae7Y7iWwvGMZBOSeuoZRL4K
         To1shhM9QN+rq02EoMWdEXe24dGPIVeP8sPzDk4WwjFgMapdTCMjfjSwGuGvENSaktuB
         u0efJqH+4ENx73XEo+qZubdn8b/PgTyoMPHWlk32H12QWQbLiZKEEMIgtzwOGDTMtFew
         mvqqOjdF1bUAzPTw9MNvcxxsDkEmQvXnLRiUNA8+CWEJntbIewn3fBo2oCPY0fftZUuV
         ChCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gq1+JtZqe+OdhKHQhHmWczD+AIQ00/IVZauq36LAU1A=;
        b=XKVKOSmWwLVTJ1UbRukYXCa2jTnxvwYV8AKCqHFnRcq3eK8QIuMdXGnAOJTXV7JrYV
         eqV11hJF9w9qJTrwzba2fP7gMd8ZdZhq0ALYksLF4HBwZ/GOFhlVlNgV6QYzZ4/zR9Ca
         B3jNlbkPpRz+9iFO+Rb0JJeyBNFV2RHJmjBCJz9v6aSKuWNTRes1A2nIQ/FKirxJNxGX
         FGv6zrk68fEMgbJ9deq7Vb+VDSUMMubMluBX5hb0QtOr0f8zmsvrj9Gatx0cxlE68HrV
         LF0CSliUVMz9e2z5x0ZLJUD55Nl2ZszKtIw5q7SIYk8d2c8ylyodfhwyw16oTr6s7qYQ
         9K9w==
X-Gm-Message-State: AOAM533vJWgClRhZqjSAfknBKbgl73HLB8dYujtNa49N/VkAg0AulgPv
        3kxPfiTEB+EXlDU7ud5LxT+NbJaj/GQMwRVICMUDNg==
X-Google-Smtp-Source: ABdhPJxOELTo0emF5aiVTp4JsWv/gNorSm2Ky5v6fFM+tuGBJ8vRhEi6Eq/ekxPt1Y8gB7Wsi7bsagfyOThQgS3YjjE=
X-Received: by 2002:a17:906:eca5:: with SMTP id qh5mr10842821ejb.161.1612283432769;
 Tue, 02 Feb 2021 08:30:32 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com> <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
In-Reply-To: <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 2 Feb 2021 11:30:22 -0500
Message-ID: <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

i just reran it with my memset bug fixed, and now get these results...
still fails with SQPOLL. (i ommited the SQPOLL without fixed flag
result since i'm working with a 5.10 kernel). I tried with and without
submitting, no difference.

with SQPOLL      with      FIXED FLAG -> FAILURE: failed with error = -22
without SQPOLL with      FIXED FLAG -> SUCCESS: timeout as expected
without SQPOLL without FIXED FLAG -> SUCCESS: timeout as expected
