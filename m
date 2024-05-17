Return-Path: <io-uring+bounces-1914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 941238C83DB
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 11:38:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 490CE284B1C
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 09:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4296624B34;
	Fri, 17 May 2024 09:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7nnnXKo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAECC1FA5;
	Fri, 17 May 2024 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715938720; cv=none; b=LYtXV8FyIDwECrOzDp3zf2PDcMK2Gk04+Kq37Fp3M+OzZTRTB8K1EOd4e7Na9Ql7BZZksuxi6t9X7w0055jStdddCic8vrxJSGzXDd/aV7nMdQ7miIpuErVDMOlQKbnMEeGD1ZT8DjHolMQkslIUvBxMHpZRWSZ+JD/81Xmayx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715938720; c=relaxed/simple;
	bh=vcW+W1wogmO6WY+GSQu3IAR/P96Rw6SpWddj5psVWwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gdtvfx1zrWDr2+27wVpxoZkNUNqQTGcCFHZtdkWsAO1+qAtpijXNpqSEqulLKIAGuBXnnEeJoAYzdc1UYAGTnFOB31LRNVuc9ZwiFbYGv4sfKYoNeQN7qC7/uDAUjW1zDpJ8DAqCOYIzbEv7afURBbDp7ldpsQ/dYPNBd7+VKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7nnnXKo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B3BC4AF0D;
	Fri, 17 May 2024 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715938719;
	bh=vcW+W1wogmO6WY+GSQu3IAR/P96Rw6SpWddj5psVWwk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Q7nnnXKoCoZCRE9y8qfd0GjlbgMZcow94ZBAhyo/a3WB7eilpoBw2+BvdmX0v1BZf
	 e7OVkid9omI+gvcN303kxsn1XDNSTYdJqgftO+q7xqgbBFEfRALDNx6MNApEOaSItp
	 R/U+wW3wKfdgVg1pSTt+l5Ktt5O2287ep0H8zh6uS0rANv32EVrNlYH0N2LN0Wkz4S
	 7JyAvYOZKqMfev4RirENIqVjY9S2NBz5t0xMnmDlB0lD8J6a25LhI7NPYbYJS3uooO
	 gi0eyy/jJtvOQvPPH73HE5rAvo90fxUfGOyoScW2xWZLVtSxLMRh/mH25kBaP3Lv2i
	 C+gw9xG0H/JCg==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5b27c804765so229613eaf.3;
        Fri, 17 May 2024 02:38:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWYCUUcc/b/FchSIKZURPFgta7rVvQ98EXrKHPJXFNwHm1NYA5mhnrnOqs5AhhxQ9GW9IakoPYM2tKBfhzrk/EyEzmJoi3rvafeJAUk4utvdM/gl8Q0DmNn+qVXUdMgmMqD7N28eXbKunqB+G5eCznmfnElM16y3btdfJz4m42lijWOBJhUrMFy8mEmV2NEgPSw2qBQsheFqZTdZfVYbQlXImgczqpO1gLjF09p1nkEr4Z6J8wUxVABJgHtADl9oMVjoWL+Y3sMeuOT3c0IKKGN4Dxt0z7elVxN4MdMm2/XgPnmczXwM2E4weNyvSvGYOUo3Dkl90oXWTCwB3ZLYTOOX3DyDPDKLYuxbGaQUBL8+WhtWwuGUB0xTB6Dt0bnoY5KbU/fG+9kK44As6lJ2NYR1485Vas5PJQxopYaNbQYGZKrDDagnzU882PHhfVixV7HYIl+4BeStudiFN7N/DWBfep9uW/SeWq5CfewEpV5Lf3eV8k3NxElPyWpSOxA6/+fW6RUzOihBnmLnDjCYTeCOtpkhqcB5stjrjHwctwJwFJWxtttDNNnrNyguRw7jsVNt6gPZGfFRHcHQg9pw7OMHZU8eus2L5UubhOWaO1vjpTW1xUxeSmHnP3lpDagZ2BgfipnFvr485MmMbecSsSkuNvMN2uUg9fsdHUmjBQkpMcYQVY0EHgYMrkejjAgzvPAv4h4eo4am5WALGnFB3CNcYUeaJLYxuzuzs3PSpK/dk6pyABso4gg0hpRt7mFgH36sxlE2vJYdkb+Ylhzt6PNwVMLWnD/0dPNbNSurY9wkoSfg+VlRhZ0Mcdtd/TIYeYJA3RTlFCmLh247gWcRQhFgjfTlo0xEw/l5O690hEm1/wM3BFIMnQy/+SMSXd/DRpx0WU7VXCYsoX8UyKC+EhFQdTCNYohD7n9LX8gfiYVyVyasai9AOwbkUAwQ==
X-Gm-Message-State: AOJu0YxGXHeHUUHqXVkQ8sPUu7cuIKrwXOWNRvlYtJoG/9dUoyF9RkvT
	EcOEQRJrDqc9Zb30XhSADfiY2PrEpiLTINFH80SW64FTRyYyGHMhaV9I/CjvzyO7Uit4iAJws/V
	0JPKARYzgJJuMcO1qT60GjRzkwAk=
X-Google-Smtp-Source: AGHT+IGDE99s+s68qJbXMtkzFnMd5s/9OBNB6sR0+sCICB0PpLHU9X3BbBFmCRlDywLZhowLPWB9T1lJ6YvckXBFFDs=
X-Received: by 2002:a05:6820:2602:b0:5b2:8017:fb68 with SMTP id
 006d021491bc7-5b2815cd95fmr22153827eaf.0.1715938718475; Fri, 17 May 2024
 02:38:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240516133454.681ba6a0@rorschach.local.home>
In-Reply-To: <20240516133454.681ba6a0@rorschach.local.home>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 17 May 2024 11:38:25 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hGNNvUq-BNHynaWr-5YVC6ugki81R70SG4uu34Rk-Mew@mail.gmail.com>
Message-ID: <CAJZ5v0hGNNvUq-BNHynaWr-5YVC6ugki81R70SG4uu34Rk-Mew@mail.gmail.com>
Subject: Re: [PATCH] tracing/treewide: Remove second parameter of __assign_str()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-block@vger.kernel.org, linux-cxl@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, virtualization@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org, iommu@lists.linux.dev, 
	linux-tegra@vger.kernel.org, netdev@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	ath12k@lists.infradead.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org, 
	selinux@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-wpan@vger.kernel.org, 
	dev@openvswitch.org, linux-s390@vger.kernel.org, 
	tipc-discussion@lists.sourceforge.net, Julia Lawall <Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 7:35=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.10 and submit it then. Hopin=
g
>    to keep the conflicts that it will cause to a minimum.
> ]
>
> With the rework of how the __string() handles dynamic strings where it
> saves off the source string in field in the helper structure[1], the
> assignment of that value to the trace event field is stored in the helper
> value and does not need to be passed in again.
>
> This means that with:
>
>   __string(field, mystring)
>
> Which use to be assigned with __assign_str(field, mystring), no longer
> needs the second parameter and it is unused. With this, __assign_str()
> will now only get a single parameter.
>
> There's over 700 users of __assign_str() and because coccinelle does not
> handle the TRACE_EVENT() macro I ended up using the following sed script:
>
>   git grep -l __assign_str | while read a ; do
>       sed -e 's/\(__assign_str([^,]*[^ ,]\) *,[^;]*/\1)/' $a > /tmp/test-=
file;
>       mv /tmp/test-file $a;
>   done
>
> I then searched for __assign_str() that did not end with ';' as those
> were multi line assignments that the sed script above would fail to catch=
.
>
> Note, the same updates will need to be done for:
>
>   __assign_str_len()
>   __assign_rel_str()
>   __assign_rel_str_len()
>
> I tested this with both an allmodconfig and an allyesconfig (build only f=
or both).
>
> [1] https://lore.kernel.org/linux-trace-kernel/20240222211442.634192653@g=
oodmis.org/
>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Acked-by: Rafael J. Wysocki <rafael@kernel.org> # for thermal

