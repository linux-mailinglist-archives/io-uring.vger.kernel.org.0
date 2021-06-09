Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F033A0A35
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 04:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhFICsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Jun 2021 22:48:47 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:35446 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFICsr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Jun 2021 22:48:47 -0400
Received: by mail-ej1-f46.google.com with SMTP id h24so35976250ejy.2
        for <io-uring@vger.kernel.org>; Tue, 08 Jun 2021 19:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dMJAIATDxck3lPc2v/vOyqYIyHEjWVevdw28uBnRll8=;
        b=vJCu8FkaI6OA/S5WUg8dM66mAya65Fay5hA/eiMY3Lre1NFLuBR0GAu7PbHt8SbNuJ
         3YxhvjAdYnFhw3cd6RDn4UKhXeuZzOKQfLKns9hAAtwpeDi3dt518h/j2QA7MZh7MYCi
         vwgUF+67Jw+sjHIq0nD6k7r7cSn48p3v2T3HFi/z6QgtAUEyMPZtkav5Wy80oAsGLE2O
         PqFJsyaViE7igCLWDnI6QZn7CKnYPtKIF0UpZAGwaHYcuD7wWL6x/HpU0U7WGvfkeOsL
         OJftkhEHQH1/uRA5GDUWCh9MO6LuUVLaWWbhUiCd702ZrvrmQYQuxElBUN2sztqmw+RA
         3+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dMJAIATDxck3lPc2v/vOyqYIyHEjWVevdw28uBnRll8=;
        b=o/cuL4EAkJHhfLbPxZruO5tlxkReTYPQjIzXgVParV8jLTphAFZWevXR1ZMdneHJlX
         EHWOOdte2P8RfWwkK/efV1EghbP4bsvCAhj4csf/yrdw3mVyYXho22H5EIBHsgKuqQic
         nYBiQWs26GxoYkrr6/QvgrpWSfEp49L0rUo16J0lOohmzsR6EmhL0HX2o0irgfW3IzrZ
         S+ifoD96gNeanYNPet1pYO1hc86Lrj/eguN6jDFgVmwEe9ICuvewEyU7IX7g+VOr0QbO
         Hl9aj+n6q+TUxVRA/mCXY90JwC941mXoyyWU1wjBfk/IGEDQ3wBvy+tiONuF1pSxS3rU
         MvJg==
X-Gm-Message-State: AOAM531A/E0/TfaUVoLOz5cYMLpaE09MDDrnJQPxVZlQ8hpiv9475oQ9
        SvXxWxlAc48wl4oWwltsRvV4Iyn+osKGnolVxRJJA49c3g==
X-Google-Smtp-Source: ABdhPJzL9fIDlYNo3jdwZcRjedeaqhqbGqBRlphCAKBf6dCq1NoGxNou4DjDXOr7lSmB1qXBkGhxlEz2kFZPkYJnhXQ=
X-Received: by 2002:a17:906:4111:: with SMTP id j17mr25998733ejk.488.1623206738453;
 Tue, 08 Jun 2021 19:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
 <3a2903574a4d03f73230047866112b2dad9b4a9e.1622467740.git.rgb@redhat.com>
 <CAHC9VhRa9dvCfPf5WHKYofrvQrGff7Lh+H4HMAhi_z3nK_rtoA@mail.gmail.com> <20210608125504.GA2268484@madcap2.tricolour.ca>
In-Reply-To: <20210608125504.GA2268484@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 8 Jun 2021 22:45:27 -0400
Message-ID: <CAHC9VhQg5WBF72UUyb32s9zB+9G41=DfdouPnudY+vL1g9bAjg@mail.gmail.com>
Subject: Re: [PATCH 1/2] audit: add filtering for io_uring records, addendum
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-audit@redhat.com,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jun 8, 2021 at 8:55 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> I should have been more explicit.  The intent was to have the fixes
> incorporated directly into your patches since they aren't committed in
> any public tree yet, exactly for bisect reasons ...

No worries, thanks for the clarification Richard.  I just wanted to
make sure since the contribution format was a bit unusual given the
context :)

Regardless, thanks again for the feedback, I'll get this incorporated.

-- 
paul moore
www.paul-moore.com
