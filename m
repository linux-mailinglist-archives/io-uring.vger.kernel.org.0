Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DC21377E7
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2020 21:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgAJU06 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jan 2020 15:26:58 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39419 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgAJU06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jan 2020 15:26:58 -0500
Received: by mail-lf1-f68.google.com with SMTP id y1so2435376lfb.6
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6RmY6iVo4NGP6Hg5M76hkN086tbBjjirfF+fQEc8us=;
        b=hdjqcu361W3mzbJATmBN+/g2zCwVbZCLH56Q046KWoiEhRaLynn8y608Hb176vrZoH
         KTohYxRRdT6IA5ZxDYMJ8477XDQWTPlj4BRkmvkjxyHKdVebJghpjCdTq3cUJ7kPsmmY
         XTns0LlP6OgATUI8m90sfn+ADFmQNS/2/4kXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6RmY6iVo4NGP6Hg5M76hkN086tbBjjirfF+fQEc8us=;
        b=FyAblHON8nbGOvfEhqTZB0N49osQ9XMo2TrbumVvvjSWWFpeIQDDVROhkXMU8aPIRM
         EeqLVLSu9noVUbNGwVFWk6s5sig5BII88n2o83qoGjpkWDAgOFmvnXf1XHIx8MnnCeUu
         D7laF6OO8vy4qG7v1jCQgMkcjKpYJQ92DQ/MY3ALnAbZSJf4qddyfOYAXYUjCeEN8sYa
         m/W5bubcRmo2k/s1qs7fGJuTXcbQNioPj1LU5QuzWB3rHs7OkeMpaNTKMZf67a4/qivk
         N6JHXdV//6596ov0tZQnU87r2jSCjw13RLyjyYDjv9V7PV+l2TzJ1eUz6THv7n8NFlSj
         73EA==
X-Gm-Message-State: APjAAAWipYb9kPUTE/CNpvggIb9YUcsCxDSv+307QB/+RP3iqLNXJxeq
        ED/oluBufhC07xtJpO7L9JUzlrGoiDM=
X-Google-Smtp-Source: APXvYqw7UBr1UEaPKOgLqNfyLTxtUq9kJQOLWymnWoFuiJxBwWXfGBeJIJTh8UZG42ewV95moSRCjg==
X-Received: by 2002:a19:cb54:: with SMTP id b81mr3405516lfg.188.1578688016610;
        Fri, 10 Jan 2020 12:26:56 -0800 (PST)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id m189sm1578103lfd.92.2020.01.10.12.26.55
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 12:26:55 -0800 (PST)
Received: by mail-lf1-f54.google.com with SMTP id y1so2435308lfb.6
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2020 12:26:55 -0800 (PST)
X-Received: by 2002:ac2:5ec3:: with SMTP id d3mr3370517lfq.176.1578688015452;
 Fri, 10 Jan 2020 12:26:55 -0800 (PST)
MIME-Version: 1.0
References: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
In-Reply-To: <4f9e9ba4-4963-52d3-7598-b406b3a4ed35@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 10 Jan 2020 12:26:39 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com>
Message-ID: <CAHk-=wgLX0Axk+3Gd6YeRcXkW6GHOk0_CSpp3fJGgmmbN8_BMA@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.5-rc
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 10, 2020 at 10:07 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> Single fix for this series, fixing a regression with the short read
> handling. This just removes it, as it cannot safely be done for all
> cases.

Hmm. The io_uring list is apparently not on lore. So you don't get
pr-tracker-bot responses.

Maybe add lkml to the cc for pull requests unconditionally?

            Linus
