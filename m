Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A441A17CE
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 00:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDGWLy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 18:11:54 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44194 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgDGWLy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 18:11:54 -0400
Received: by mail-pg1-f195.google.com with SMTP id n13so946000pgp.11
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 15:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZlRcbXOf6HEHPqaUtEt5qW0LJW/4fQLhONtHcH/YbYg=;
        b=t1VL27es4c9NxuoFLnxPgAyDoUZpMqTBG1+IAD5pXiKUk0D3i0+cQIiqNUl0Zu0Iu5
         DimyMnS5uU2KylblxzlrK74pTcaFDm120JTuGOwVBuqrnqzRHxx7vk8fA3ZkBCrgkZze
         CxaW4yIQL6KOmXiFUK7zfc63bnZ4eImRULrmbpWym8Junu3aapuRbJtVVZ0o5M+E/IAA
         jQgih3q4QDkHA+n9nUlcMV+33dKeJtT8BpdVOmMCTjbmU3G83gdGj+GGp1kVfuyh9JOZ
         CFrLF23dzbQ0acitblScW+2Eh7URm0ZOmVaz6+un8ZafMEPFb2qpHNmBSNRZo9TT+gfH
         hHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZlRcbXOf6HEHPqaUtEt5qW0LJW/4fQLhONtHcH/YbYg=;
        b=K8BOaF44dWbBd/euCKoEtM1ddbg1fU7bbP0Tq+OQCnS1fMeafJmK3pL1AvfT7MfPEP
         hPxVSaI8GzDovASaJEJtIxx/3sY5zXsQHuOjsfzPVFrf93ZRtuyt95xmqtNYtDEqvC73
         h+8Yt0IMEAbemmU0lP+ymLl0plGV9XnDq8m0qM4kCX1ZWNQyGhKPBCXJMb4fllXkrGxl
         FL76747UR7ttHSMyYaEV5WTmhTotpqlRywQUtGgtF+UvrkS6pZsb9zRC0MPa6IbdLbyf
         fi3RyJEB/lxaau62J5/9DJepniv6jywMx91huqhDmzNiq8ZlSv8q96kKqOXUwigdfe8N
         DgOg==
X-Gm-Message-State: AGi0PuYaRwqhhXCL6h4qE4eO8dLH3VbHpwz1BZyePFTxzHl5av0LzXq8
        osom1UASJMSvYe8RQea8bM5+vSLclzq4oA==
X-Google-Smtp-Source: APiQypKJnbpwl4oUhRDz6LOIItWZPMAvgXyTrDe6r+hrcBIQeI7XMfYHPYkrEReywB2XfZs1EHxgkQ==
X-Received: by 2002:aa7:8659:: with SMTP id a25mr4404971pfo.173.1586297511841;
        Tue, 07 Apr 2020 15:11:51 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id b26sm12260558pfd.98.2020.04.07.15.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:11:51 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] Support userspace-selected fds
To:     Josh Triplett <josh@joshtriplett.org>, io-uring@vger.kernel.org
References: <cover.1585978979.git.josh@joshtriplett.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2392e6e-d96d-0a6c-0f1d-95152544cb07@kernel.dk>
Date:   Tue, 7 Apr 2020 15:11:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1585978979.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/20 10:57 PM, Josh Triplett wrote:
> (Note: numbering this updated version v3, to avoid confusion with Jens'
> v2 that built on my v1. Jens, if you like this approach, please feel
> free to stack your additional patches from the io_uring-fd-select branch
> atop this series. 5.8 material, not intended for the current merge window.)
> 
> This new version has an API to atomically increase the minimum fd and
> return the previous minimum, rather than just getting and setting the
> minimum; this makes it easier to allocate a range. (A library that might
> initialize after the program has already opened other file descriptors may need
> to check for existing open fds in the range after reserving it, and
> reserve more fds if needed; this can be done entirely in userspace, and
> we can't really do anything simpler in the kernel due to limitations on
> file-descriptor semantics, so this patch series avoids introducing any
> extra complexity in the kernel.)
> 
> This new version also supports a __get_specific_unused_fd_flags call
> which accepts the limit for RLIMIT_NOFILE as an argument, analogous to
> __get_unused_fd_flags, since io_uring needs that to correctly handle
> RLIMIT_NOFILE.
> 
> 
> Inspired by the X protocol's handling of XIDs, allow userspace to select
> the file descriptor opened by a call like openat2, so that it can use
> the resulting file descriptor in subsequent system calls without waiting
> for the response the initial openat2 syscall.
> 
> The first patch is independent of the other two; it allows reserving
> file descriptors below a certain minimum for userspace-selected fd
> allocation only.
> 
> The second patch implements userspace-selected fd allocation for
> openat2, introducing a new O_SPECIFIC_FD flag and an fd field in struct
> open_how. In io_uring, this allows sequences like openat2/read/close
> without waiting for the openat2 to complete. Multiple such sequences can
> overlap, as long as each uses a distinct file descriptor.
> 
> The third patch adds userspace-selected fd allocation to pipe2 as well.
> I did this partly as a demonstration of how simple it is to wire up
> O_SPECIFIC_FD support for a new fd-allocating system call, and partly in
> the hopes that this may make it more useful to wire up io_uring support
> for pipe2 in the future.

This looks pretty clean and flexible to me, and it'll work fine for
io_uring.

Care to post this a bit wider (and CC Al)?

-- 
Jens Axboe

