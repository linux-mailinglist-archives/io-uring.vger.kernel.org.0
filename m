Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFB743E92D
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhJ1UDa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhJ1UD2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkO4OH+SoI9ZGH404m4Yeyuj6hwvavJZEOWdrwvyKOw=;
        b=h2TZnuEEa7VBX9yVeQeOuTzCwrwM9aQEAjpGjih6GtPp+wj8Dah/m3nuQXOukNttaNS/SR
        /NukjUROml02Hy24FNa9ssvRsRaenG/5x6iMvp7QpRfm0xHSVnqvFknZPLWmrFBloN1Vu/
        pqJzhovy44G1KXFk87WEwZW0q6WTApY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-E0TjzdSPP2q6B4R6Prh-Cg-1; Thu, 28 Oct 2021 16:00:59 -0400
X-MC-Unique: E0TjzdSPP2q6B4R6Prh-Cg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B5D6802682
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:00:58 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26DE8380;
        Thu, 28 Oct 2021 20:00:56 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 2/7] add support for the uring filter list
Date:   Thu, 28 Oct 2021 15:59:34 -0400
Message-Id: <20211028195939.3102767-3-rgb@redhat.com>
In-Reply-To: <20211028195939.3102767-1-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel support to audit io_uring operations filtering was added with
commit 67daf270cebc ("audit: add filtering for io_uring records").  Add sup=
port
for the "uring" filter list to auditctl.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 docs/audit.rules.7         |  19 ++++--
 docs/audit_add_rule_data.3 |   4 ++
 docs/auditctl.8            |  10 ++-
 lib/flagtab.h              |  11 ++--
 lib/libaudit.c             |  50 ++++++++++++---
 lib/libaudit.h             |   7 +++
 lib/lookup_table.c         |  20 ++++++
 lib/private.h              |   1 +
 src/auditctl-listing.c     |  52 ++++++++++------
 src/auditctl.c             | 121 ++++++++++++++++++++++++++++++++-----
 10 files changed, 240 insertions(+), 55 deletions(-)

diff --git a/docs/audit.rules.7 b/docs/audit.rules.7
index 40263ec6807d..ec4fa7ececc7 100644
--- a/docs/audit.rules.7
+++ b/docs/audit.rules.7
@@ -3,7 +3,7 @@
 audit.rules \- a set of rules loaded in the kernel audit system
 .SH DESCRIPTION
 \fBaudit.rules\fP is a file containing audit rules that will be loaded by =
the audit daemon's init script whenever the daemon is started. The auditctl=
 program is used by the initscripts to perform this operation. The syntax f=
or the rules is essentially the same as when typing in an auditctl command =
at a shell prompt except you do not need to type the auditctl command name =
since that is implied. The audit rules come in 3 varieties:
-.IR control ", " file ", and " syscall ".
+.IR control ", " file ", and " syscall/uringop ".
=20
 .SS Control
 Control commands generally involve configuring the audit system rather tha=
n telling it what to watch for. These commands typically include deleting a=
ll rules, setting the size of the kernel's backlog queue, setting the failu=
re mode, setting the event rate limit, or to tell auditctl to ignore syntax=
 errors in the rules and continue loading. Generally, these rules are at th=
e top of the rules file.
@@ -32,7 +32,7 @@ where the permission are any one of the following:
 - change in the file's attribute
 .RE
=20
-Watches can also be created using the syscall format described below which=
 allow for greater flexibility and options. Using syscall rules you can cho=
ose between
+Watches can also be created using the syscall format described below which=
 allow for greater flexibility and options. Using syscall/uringop rules you=
 can choose between
 .B path
 and
 .B dir
@@ -43,9 +43,9 @@ rule.
 .SS System Call
 The system call rules are loaded into a matching engine that intercepts ea=
ch syscall that all programs on the system makes. Therefore it is very impo=
rtant to only use syscall rules when you have to since these affect perform=
ance. The more rules, the bigger the performance hit. You can help the perf=
ormance, though, by combining syscalls into one rule whenever possible.
=20
-The Linux kernel has 5 rule matching lists or filters as they are sometime=
s called. They are: task, exit, user, exclude and filesystem. The task list=
 is checked only during the fork or clone syscalls. It is rarely used in pr=
actice.
+The Linux kernel has 6 rule matching lists or filters as they are sometime=
s called. They are: task, exit, user, exclude, filesystem, and uring. The t=
ask list is checked only during the fork or clone syscalls. It is rarely us=
ed in practice.
=20
-The exit filter is the place where all syscall and file system audit reque=
sts are evaluated.
+The exit filter is the place where all syscall and file system audit reque=
sts are evaluated.  The uring filter is the place where all uring operation=
s and file system audit requests are evaluated.
=20
 The user filter is used to filter (remove) some events that originate in u=
ser space.  By default, any event originating in user space is allowed. So,=
 if there are some events that you do not want to see, then this is a place=
 where some can be removed. See auditctl(8) for fields that are valid.
=20
@@ -71,7 +71,7 @@ option tells the kernel's rule matching engine that we wa=
nt to append a rule at
 .RE
=20
 The action and list are separated by a comma but no space in between. Vali=
d lists are:
-.IR task ", " exit ", " user ", " exclude ", and " filesystem ". Their mea=
ning was explained earlier.
+.IR task ", " exit ", " user ", " exclude ", " filesystem ", and " uring "=
. Their meaning was explained earlier.
=20
 Next in the rule would normally be the
 .B \-S
@@ -95,6 +95,15 @@ These individual checks are "anded" and both have to be =
true.
=20
 The last thing to know about syscall rules is that you can add a key field=
 which is a free form text string that you want inserted into the event to =
help identify its meaning. This is discussed in more detail in the NOTES se=
ction.
=20
+.SS Uring Operations
+Uring operations are similar to system calls in that they are initiated by=
 user actions, but once the action is set up, information is passed between=
 userspace and kernel space bidirectionally via shared buffers.  There is a=
 different list of operations that use the same operations list mechanism s=
o system calls and uring operations are mutually exclusive.
+
+Uring op rules take the general form of:
+
+.nf
+.B \-a action,list \-U uringop \-F field=3Dvalue \-k keyname
+.fi
+
 .SH NOTES
 The purpose of auditing is to be able to do an investigation periodically =
or whenever an incident occurs. A few simple steps in planning up front wil=
l make this job easier. The best advice is to use keys in both the watches =
and system call rules to give the rule a meaning. If rules are related or t=
ogether meet a specific requirement, then give them a common key name. You =
can use this during your investigation to select only results with a specif=
ic meaning.
=20
diff --git a/docs/audit_add_rule_data.3 b/docs/audit_add_rule_data.3
index 61d1902e702b..e86c3a1b0fef 100644
--- a/docs/audit_add_rule_data.3
+++ b/docs/audit_add_rule_data.3
@@ -27,6 +27,10 @@ AUDIT_FILTER_EXCLUDE - Apply rule at audit_log_start. Th=
is is the exclude filter
 \(bu
 AUDIT_FILTER_FS - Apply rule when adding PATH auxiliary records to SYSCALL=
 events. This is the filesystem filter. This is used to ignore PATH records=
 that are not of interest.
 .LP
+.TP
+\(bu
+AUDIT_FILTER_URING_EXIT - Apply rule at uring exit. This is the main filte=
r that is used for uring ops and filesystem watches. Normally all uring ops=
 do not trigger events, so this is normally used to specify events that are=
 of interest.
+.LP
=20
 .PP
 The rule's action has two possible values:
diff --git a/docs/auditctl.8 b/docs/auditctl.8
index 8069259bcb47..515c5a71f861 100644
--- a/docs/auditctl.8
+++ b/docs/auditctl.8
@@ -92,6 +92,9 @@ Add a rule to the event type exclusion filter list. This =
list is used to filter
 .TP
 .B filesystem
 Add a rule that will be applied to a whole filesystem. The filesystem must=
 be identified with a fstype field. Normally this filter is used to exclude=
 any events for a whole filesystem such as tracefs or debugfs.
+.TP
+.B uring
+Add a rule to the uring op exit list. This list is used upon exit from a u=
ring operation call to determine if an audit event should be created.
 .RE
=20
 The following describes the valid \fIactions\fP for the rule:
@@ -101,7 +104,7 @@ The following describes the valid \fIactions\fP for the=
 rule:
 No audit records will be generated. This can be used to suppress event gen=
eration. In general, you want suppressions at the top of the list instead o=
f the bottom. This is because the event triggers on the first matching rule.
 .TP
 .B always
-Allocate an audit context, always fill it in at syscall entry time, and al=
ways write out a record at syscall exit time.
+Allocate an audit context, always fill it in at syscall/uringop entry time=
, and always write out a record at syscall/uringop exit time.
 .RE
 .TP
 .BI \-A\  list , action
@@ -120,7 +123,7 @@ The two groups of uid and gid cannot be mixed. But any =
comparison within the gro
=20
 .TP
 .BI \-d\  list , action
-Delete rule from \fIlist\fP with \fIaction\fP. The rule is deleted only if=
 it exactly matches syscall name(s) and every field name and value.
+Delete rule from \fIlist\fP with \fIaction\fP. The rule is deleted only if=
 it exactly matches syscall/uringop name(s) and every field name and value.
 .TP
 \fB\-F\fP [\fIn\fP\fB=3D\fP\fIv\fP | \fIn\fP\fB!=3D\fP\fIv\fP | \fIn\fP\fB=
<\fP\fIv\fP | \fIn\fP\fB>\fP\fIv\fP | \fIn\fP\fB<=3D\fP\fIv\fP | \fIn\fP\fB=
>=3D\fP\fIv\fP | \fIn\fP\fB&\fP\fIv\fP | \fIn\fP\fB&=3D\fP\fIv\fP]
 Build a rule field: name, operation, value. You may have up to 64 fields p=
assed on a single command line. Each one must start with \fB\-F\fP. Each fi=
eld equation is anded with each other (as well as equations starting with \=
fB\-C\fP) to trigger an audit record. There are 8 operators supported - equ=
al, not equal, less than, greater than, less than or equal, and greater tha=
n or equal, bit mask, and bit test respectively. Bit test will "and" the va=
lues and check that they are equal, bit mask just "ands" the values. Fields=
 that take a user ID may instead have the user's name; the program will con=
vert the name to user ID. The same is true of group names. Valid fields are:
@@ -260,6 +263,9 @@ Describe the permission access type that a file system =
watch will trigger on. \f
 \fB\-S\fP [\fISyscall name or number\fP|\fBall\fP]
 Any \fIsyscall name\fP or \fInumber\fP may be used. The word '\fBall\fP' m=
ay also be used.  If the given syscall is made by a program, then start an =
audit record. If a field rule is given and no syscall is specified, it will=
 default to all syscalls. You may also specify multiple syscalls in the sam=
e rule by using multiple \-S options in the same rule. Doing so improves pe=
rformance since fewer rules need to be evaluated. Alternatively, you may pa=
ss a comma separated list of syscall names. If you are on a bi-arch system,=
 like x86_64, you should be aware that auditctl simply takes the text, look=
s it up for the native arch (in this case b64) and sends that rule to the k=
ernel. If there are no additional arch directives, IT WILL APPLY TO BOTH 32=
 & 64 BIT SYSCALLS. This can have undesirable effects since there is no gua=
rantee that any syscall has the same number on both 32 and 64 bit interface=
s. You will likely want to control this and write 2 rules, one with arch eq=
ual to b32 and one with b64 to make sure the kernel finds the events that y=
ou intend. See the arch field discussion for more info.
 .TP
+\fB\-U\fP [\fIUring operation name or number\fP|\fBall\fP]
+Any \fIuring operation name\fP or \fInumber\fP may be used. The word '\fBa=
ll\fP' may also be used.  If the given uring operation is made by a program=
, then start an audit record. If a field rule is given and no uring operati=
on is specified, it will default to all uring operations. You may also spec=
ify multiple uring operations in the same rule by using multiple \-S option=
s in the same rule. Doing so improves performance since fewer rules need to=
 be evaluated. Alternatively, you may pass a comma separated list of uring =
operation names.
+.TP
 .BI \-w\  path
 Insert a watch for the file system object at \fIpath\fP. You cannot insert=
 a watch to the top level directory. This is prohibited by the kernel. Wild=
cards are not supported either and will generate a warning. The way that wa=
tches work is by tracking the inode internally. If you place a watch on a f=
ile, its the same as using the \-F path option on a syscall rule. If you pl=
ace a watch on a directory, its the same as using the \-F dir option on a s=
yscall rule. The \-w form of writing watches is for backwards compatibility=
 and the syscall based form is more expressive. Unlike most syscall auditin=
g rules, watches do not impact performance based on the number of rules sen=
t to the kernel. The only valid options when using a watch are the \-p and =
\-k. If you need to do anything fancy like audit a specific user accessing =
a file, then use the syscall auditing form with the path or dir fields. See=
 the EXAMPLES section for an example of converting one form to another.
 .TP
diff --git a/lib/flagtab.h b/lib/flagtab.h
index 7a618e0fe126..0fa4443e6ce3 100644
--- a/lib/flagtab.h
+++ b/lib/flagtab.h
@@ -20,8 +20,9 @@
  *      Steve Grubb <sgrubb@redhat.com>
  *      Richard Guy Briggs <rgb@redhat.com>
  */
-_S(AUDIT_FILTER_TASK,    "task"      )
-_S(AUDIT_FILTER_EXIT,    "exit"      )
-_S(AUDIT_FILTER_USER,    "user"      )
-_S(AUDIT_FILTER_EXCLUDE, "exclude"   )
-_S(AUDIT_FILTER_FS,      "filesystem")
+_S(AUDIT_FILTER_TASK,       "task"      )
+_S(AUDIT_FILTER_EXIT,       "exit"      )
+_S(AUDIT_FILTER_USER,       "user"      )
+_S(AUDIT_FILTER_EXCLUDE,    "exclude"   )
+_S(AUDIT_FILTER_FS,         "filesystem")
+_S(AUDIT_FILTER_URING_EXIT, "uring"     )
diff --git a/lib/libaudit.c b/lib/libaudit.c
index 54e276156ef0..3790444f4497 100644
--- a/lib/libaudit.c
+++ b/lib/libaudit.c
@@ -86,6 +86,7 @@ static const struct nv_list failure_actions[] =3D
 int _audit_permadded =3D 0;
 int _audit_archadded =3D 0;
 int _audit_syscalladded =3D 0;
+int _audit_uringopadded =3D 0;
 int _audit_exeadded =3D 0;
 int _audit_filterfsadded =3D 0;
 unsigned int _audit_elf =3D 0U;
@@ -999,6 +1000,26 @@ int audit_rule_syscallbyname_data(struct audit_rule_d=
ata *rule,
 	return -1;
 }
=20
+int audit_rule_uringopbyname_data(struct audit_rule_data *rule,
+                                  const char *uringop)
+{
+	int nr, i;
+
+	if (!strcmp(uringop, "all")) {
+		for (i =3D 0; i < AUDIT_BITMASK_SIZE; i++)
+			rule->mask[i] =3D ~0;
+		return 0;
+	}
+	nr =3D audit_name_to_uringop(uringop);
+	if (nr < 0) {
+		if (isdigit(uringop[0]))
+			nr =3D strtol(uringop, NULL, 0);
+	}
+	if (nr >=3D 0)
+		return audit_rule_syscall_data(rule, nr);
+	return -1;
+}
+
 int audit_rule_interfield_comp_data(struct audit_rule_data **rulep,
 					 const char *pair,
 					 int flags)
@@ -1044,7 +1065,7 @@ int audit_rule_interfield_comp_data(struct audit_rule=
_data **rulep,
 		return -EAU_COMPVALUNKNOWN;
=20
 	/* Interfield comparison can only be in exit filter */
-	if (flags !=3D AUDIT_FILTER_EXIT)
+	if (flags !=3D AUDIT_FILTER_EXIT && flags !=3D AUDIT_FILTER_URING_EXIT)
 		return -EAU_EXITONLY;
=20
 	// It should always be AUDIT_FIELD_COMPARE
@@ -1557,7 +1578,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 			}
 			break;
 		case AUDIT_EXIT:
-			if (flags !=3D AUDIT_FILTER_EXIT)
+			if (flags !=3D AUDIT_FILTER_EXIT &&
+			    flags !=3D AUDIT_FILTER_URING_EXIT)
 				return -EAU_EXITONLY;
 			vlen =3D strlen(v);
 			if (isdigit((char)*(v)))
@@ -1599,7 +1621,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 		case AUDIT_DIR:
 			/* Watch & object filtering is invalid on anything
 			 * but exit */
-			if (flags !=3D AUDIT_FILTER_EXIT)
+			if (flags !=3D AUDIT_FILTER_EXIT &&
+			    flags !=3D AUDIT_FILTER_URING_EXIT)
 				return -EAU_EXITONLY;
 			if (field =3D=3D AUDIT_WATCH || field =3D=3D AUDIT_DIR)
 				_audit_permadded =3D 1;
@@ -1621,9 +1644,11 @@ int audit_rule_fieldpair_data(struct audit_rule_data=
 **rulep, const char *pair,
 				_audit_exeadded =3D 1;
 			}
 			if (field =3D=3D AUDIT_FILTERKEY &&
-				!(_audit_syscalladded || _audit_permadded ||
-				_audit_exeadded ||
-				_audit_filterfsadded))
+				!(_audit_syscalladded ||
+				  _audit_uringopadded ||
+				  _audit_permadded ||
+				  _audit_exeadded ||
+				  _audit_filterfsadded))
                                 return -EAU_KEYDEP;
 			vlen =3D strlen(v);
 			if (field =3D=3D AUDIT_FILTERKEY &&
@@ -1712,7 +1737,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 			}
 			break;
 		case AUDIT_FILETYPE:
-			if (!(flags =3D=3D AUDIT_FILTER_EXIT))
+			if (!(flags =3D=3D AUDIT_FILTER_EXIT ||
+			      flags =3D=3D AUDIT_FILTER_URING_EXIT))
 				return -EAU_EXITONLY;
 			rule->values[rule->field_count] =3D
 				audit_name_to_ftype(v);
@@ -1754,7 +1780,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 				return -EAU_FIELDNOSUPPORT;
 			if (flags !=3D AUDIT_FILTER_EXCLUDE &&
 			    flags !=3D AUDIT_FILTER_USER &&
-			    flags !=3D AUDIT_FILTER_EXIT)
+			    flags !=3D AUDIT_FILTER_EXIT &&
+			    flags !=3D AUDIT_FILTER_URING_EXIT)
 				return -EAU_FIELDNOFILTER;
 			// Do positive & negative separate for 32 bit systems
 			vlen =3D strlen(v);
@@ -1775,7 +1802,8 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 			break;
 		case AUDIT_DEVMAJOR...AUDIT_INODE:
 		case AUDIT_SUCCESS:
-			if (flags !=3D AUDIT_FILTER_EXIT)
+			if (flags !=3D AUDIT_FILTER_EXIT &&
+			    flags !=3D AUDIT_FILTER_URING_EXIT)
 				return -EAU_EXITONLY;
 			/* fallthrough */
 		default:
@@ -1785,7 +1813,9 @@ int audit_rule_fieldpair_data(struct audit_rule_data =
**rulep, const char *pair,
 					return -EAU_OPEQNOTEQ;
 			}
=20
-			if (field =3D=3D AUDIT_PPID && !(flags=3D=3DAUDIT_FILTER_EXIT))
+			if (field =3D=3D AUDIT_PPID &&
+			    !(flags =3D=3D AUDIT_FILTER_EXIT ||
+			      flags =3D=3D AUDIT_FILTER_URING_EXIT))
 				return -EAU_EXITONLY;
=20
 			if (!isdigit((char)*(v)))
diff --git a/lib/libaudit.h b/lib/libaudit.h
index 08b7d22678aa..a73edc677df0 100644
--- a/lib/libaudit.h
+++ b/lib/libaudit.h
@@ -341,6 +341,9 @@ extern "C" {
 #ifndef AUDIT_FILTER_EXCLUDE
 #define AUDIT_FILTER_EXCLUDE	AUDIT_FILTER_TYPE
 #endif
+#ifndef AUDIT_FILTER_URING_EXIT
+#define AUDIT_FILTER_URING_EXIT	0x07 /* filter on exit from io_uring op */
+#endif
 #define AUDIT_FILTER_MASK	0x07	/* Mask to get actual filter */
 #define AUDIT_FILTER_UNSET	0x80	/* This value means filter is unset */
=20
@@ -612,6 +615,8 @@ extern int        audit_name_to_field(const char *field=
);
 extern const char *audit_field_to_name(int field);
 extern int        audit_name_to_syscall(const char *sc, int machine);
 extern const char *audit_syscall_to_name(int sc, int machine);
+extern int        audit_name_to_uringop(const char *uringopop);
+extern const char *audit_uringop_to_name(int uringop);
 extern int        audit_name_to_flag(const char *flag);
 extern const char *audit_flag_to_name(int flag);
 extern int        audit_name_to_action(const char *action);
@@ -706,6 +711,8 @@ extern struct audit_rule_data *audit_rule_create_data(v=
oid);
 extern void audit_rule_init_data(struct audit_rule_data *rule);
 extern int audit_rule_syscallbyname_data(struct audit_rule_data *rule,
                                           const char *scall);
+extern int audit_rule_uringopbyname_data(struct audit_rule_data *rule,
+                                          const char *uringop);
 /* Note that the following function takes a **, where audit_rule_fieldpair=
()
  * takes just a *.  That structure may need to be reallocated as a result =
of
  * adding new fields */
diff --git a/lib/lookup_table.c b/lib/lookup_table.c
index 23678a4d142e..ca619fba930d 100644
--- a/lib/lookup_table.c
+++ b/lib/lookup_table.c
@@ -142,6 +142,18 @@ int audit_name_to_syscall(const char *sc, int machine)
 	return -1;
 }
=20
+int audit_name_to_uringop(const char *uringop)
+{
+	int res =3D -1, found =3D 0;
+
+#ifndef NO_TABLES
+	//found =3D uringop_s2i(uringop, &res);
+#endif
+	if (found)
+		return res;
+	return -1;
+}
+
 const char *audit_syscall_to_name(int sc, int machine)
 {
 #ifndef NO_TABLES
@@ -172,6 +184,14 @@ const char *audit_syscall_to_name(int sc, int machine)
 	return NULL;
 }
=20
+const char *audit_uringop_to_name(int uringop)
+{
+#ifndef NO_TABLES
+	//return uringop_i2s(uringop);
+#endif
+	return NULL;
+}
+
 int audit_name_to_flag(const char *flag)
 {
 	int res;
diff --git a/lib/private.h b/lib/private.h
index c3a7364fcfb8..b0d3fa4109c5 100644
--- a/lib/private.h
+++ b/lib/private.h
@@ -135,6 +135,7 @@ AUDIT_HIDDEN_END
 extern int _audit_permadded;
 extern int _audit_archadded;
 extern int _audit_syscalladded;
+extern int _audit_uringopadded;
 extern int _audit_exeadded;
 extern int _audit_filterfsadded;
 extern unsigned int _audit_elf;
diff --git a/src/auditctl-listing.c b/src/auditctl-listing.c
index a5d6bc2b046f..3d80906ffd24 100644
--- a/src/auditctl-listing.c
+++ b/src/auditctl-listing.c
@@ -137,15 +137,22 @@ static int print_syscall(const struct audit_rule_data=
 *r, unsigned int *sc)
 	int all =3D 1;
 	unsigned int i;
 	int machine =3D audit_detect_machine();
-
-	/* Rules on the following filters do not take a syscall */
-	if (((r->flags & AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_USER) ||
-	    ((r->flags & AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_TASK) ||
-	    ((r->flags &AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_EXCLUDE) ||
-	    ((r->flags &AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_FS))
+	int uring =3D 0;
+
+	/* Rules on the following filters do not take a syscall (or uringop) */
+	switch (r->flags & AUDIT_FILTER_MASK) {
+	case AUDIT_FILTER_USER:
+	case AUDIT_FILTER_TASK:
+	case AUDIT_FILTER_EXCLUDE:
+	case AUDIT_FILTER_FS:
 		return 0;
+		break;
+	case AUDIT_FILTER_URING_EXIT:
+		uring =3D 1;
+		break;
+	}
=20
-	/* See if its all or specific syscalls */
+	/* See if its all or specific syscalls/uringops */
 	for (i =3D 0; i < (AUDIT_BITMASK_SIZE-1); i++) {
 		if (r->mask[i] !=3D (uint32_t)~0) {
 			all =3D 0;
@@ -154,21 +161,32 @@ static int print_syscall(const struct audit_rule_data=
 *r, unsigned int *sc)
 	}
=20
 	if (all) {
-		printf(" -S all");
+		if (uring)
+			printf(" -U all");
+		else
+			printf(" -S all");
 		count =3D i;
 	} else for (i =3D 0; i < AUDIT_BITMASK_SIZE * 32; i++) {
 		int word =3D AUDIT_WORD(i);
 		int bit  =3D AUDIT_BIT(i);
 		if (r->mask[word] & bit) {
 			const char *ptr;
-			if (_audit_elf)
-				machine =3D audit_elf_to_machine(_audit_elf);
-			if (machine < 0)
-				ptr =3D NULL;
-			else
-				ptr =3D audit_syscall_to_name(i, machine);
+
+			if (uring)
+				ptr =3D audit_uringop_to_name(i);
+			else {
+				if (_audit_elf)
+					machine =3D audit_elf_to_machine(_audit_elf);
+				if (machine < 0)
+					ptr =3D NULL;
+				else
+					ptr =3D audit_syscall_to_name(i, machine);
+			}
 			if (!count)
-				printf(" -S ");
+				if (uring)
+					printf(" -U ");
+				else
+					printf(" -S ");
 			if (ptr)
 				printf("%s%s", !count ? "" : ",", ptr);
 			else
@@ -297,7 +315,7 @@ static void print_rule(const struct audit_rule_data *r)
 	int mach =3D -1, watch =3D is_watch(r);
 	unsigned long long a0 =3D 0, a1 =3D 0;
=20
-	if (!watch) { /* This is syscall auditing */
+	if (!watch) { /* This is syscall or uring auditing */
 		printf("-a %s,%s",
 			audit_action_to_name((int)r->action),
 				audit_flag_to_name(r->flags));
@@ -310,7 +328,7 @@ static void print_rule(const struct audit_rule_data *r)
 				mach =3D print_arch(r->values[i], op);
 			}
 		}
-		// And last do the syscalls
+		// And last do the syscalls/uringops
 		count =3D print_syscall(r, &sc);
 	}
=20
diff --git a/src/auditctl.c b/src/auditctl.c
index f9bfc2a247d2..74df4f17f887 100644
--- a/src/auditctl.c
+++ b/src/auditctl.c
@@ -76,6 +76,7 @@ static int reset_vars(void)
 {
 	list_requested =3D 0;
 	_audit_syscalladded =3D 0;
+	_audit_uringopadded =3D 0;
 	_audit_permadded =3D 0;
 	_audit_archadded =3D 0;
 	_audit_exeadded =3D 0;
@@ -110,7 +111,7 @@ static void usage(void)
      "    -C f=3Df                            Compare collected fields if =
available:\n"
      "                                      Field name, operator(=3D,!=3D)=
, field name\n"
      "    -d <l,a>                          Delete rule from <l>ist with <=
a>ction\n"
-     "                                      l=3Dtask,exit,user,exclude,fil=
esystem\n"
+     "                                      l=3Dtask,exit,user,exclude,fil=
esystem,uring\n"
      "                                      a=3Dnever,always\n"
      "    -D                                Delete all rules and watches\n"
      "    -e [0..2]                         Set enabled flag\n"
@@ -132,6 +133,7 @@ static void usage(void)
      "    -S syscall                        Build rule: syscall name or nu=
mber\n"
      "    --signal <signal>                 Send the specified signal to t=
he daemon\n"
      "    -t                                Trim directory watches\n"
+     "    -U uringop                        Build rule: uring op name or n=
umber\n"
      "    -v                                Version\n"
      "    -w <path>                         Insert watch at <path>\n"
      "    -W <path>                         Remove watch at <path>\n"
@@ -164,6 +166,8 @@ static int lookup_filter(const char *str, int *filter)
 		exclude =3D 1;
 	} else if (strcmp(str, "filesystem") =3D=3D 0)
 		*filter =3D AUDIT_FILTER_FS;
+	else if (strcmp(str, "uring") =3D=3D 0)
+		*filter =3D AUDIT_FILTER_URING_EXIT;
 	else
 		return 2;
 	return 0;
@@ -541,6 +545,36 @@ static int parse_syscall(const char *optarg)
 	return audit_rule_syscallbyname_data(rule_new, optarg);
 }
=20
+static int parse_uringop(const char *optarg)
+{
+	int retval =3D 0;
+	char *saved;
+
+	if (strchr(optarg, ',')) {
+		char *ptr, *tmp =3D strdup(optarg);
+		if (tmp =3D=3D NULL)
+			return -1;
+		ptr =3D strtok_r(tmp, ",", &saved);
+		while (ptr) {
+			retval =3D audit_rule_uringopbyname_data(rule_new, ptr);
+			if (retval !=3D 0) {
+				if (retval =3D=3D -1) {
+					audit_msg(LOG_ERR,
+						"Uring op name unknown: %s",
+						ptr);
+					retval =3D -3; // error reported
+				}
+				break;
+			}
+			ptr =3D strtok_r(NULL, ",", &saved);
+		}
+		free(tmp);
+		return retval;
+	}
+
+	return audit_rule_uringopbyname_data(rule_new, optarg);
+}
+
 static struct option long_opts[] =3D
 {
 #if HAVE_DECL_AUDIT_FEATURE_VERSION =3D=3D 1
@@ -576,7 +610,7 @@ static int setopt(int count, int lineno, char *vars[])
     keylen =3D AUDIT_MAX_KEY_LEN;
=20
     while ((retval >=3D 0) && (c =3D getopt_long(count, vars,
-			"hicslDvtC:e:f:r:b:a:A:d:S:F:m:R:w:W:k:p:q:",
+			"hicslDvtC:e:f:r:b:a:A:d:S:U:F:m:R:w:W:k:p:q:",
 			long_opts, &lidx)) !=3D EOF) {
 	int flags =3D AUDIT_FILTER_UNSET;
 	rc =3D 10;	// Init to something impossible to see if unused.
@@ -715,9 +749,10 @@ static int setopt(int count, int lineno, char *vars[])
 			retval =3D -1;
 		break;
         case 'a':
-		if (strstr(optarg, "task") && _audit_syscalladded) {
+		if (strstr(optarg, "task") && (_audit_syscalladded ||
+					       _audit_uringopadded)) {
 			audit_msg(LOG_ERR,
-				"Syscall auditing requested for task list");
+				"Syscall or uring op auditing requested for task list");
 			retval =3D -1;
 		} else {
 			rc =3D audit_rule_setup(optarg, &add, &action);
@@ -739,9 +774,10 @@ static int setopt(int count, int lineno, char *vars[])
 		}
 		break;
         case 'A':=20
-		if (strstr(optarg, "task") && _audit_syscalladded) {
-			audit_msg(LOG_ERR,=20
-			   "Error: syscall auditing requested for task list");
+		if (strstr(optarg, "task") && (_audit_syscalladded ||
+					       _audit_uringopadded)) {
+			audit_msg(LOG_ERR,
+				"Syscall or uring op auditing requested for task list");
 			retval =3D -1;
 		} else {
 			rc =3D audit_rule_setup(optarg, &add, &action);
@@ -809,6 +845,10 @@ static int setopt(int count, int lineno, char *vars[])
 			audit_msg(LOG_ERR,=20
 		    "Error: syscall auditing cannot be put on exclude list");
 			return -1;
+		} else if (((add | del) & AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_URING_E=
XIT) {
+			audit_msg(LOG_ERR,=20
+		    "Error: syscall auditing cannot be put on uringop list");
+			return -1;
 		} else {
 			if (unknown_arch) {
 				int machine;
@@ -853,14 +893,63 @@ static int setopt(int count, int lineno, char *vars[])
 				break;
 		}}
 		break;
+        case 'U':
+		/* Do some checking to make sure that we are not adding a
+		 * uring op rule to a list that does not make sense. */
+		if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_TASK || (del &
+				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_TASK)) {
+			audit_msg(LOG_ERR,
+			  "Error: uring op auditing being added to task list");
+			return -1;
+		} else if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_USER || (del &
+				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_USER)) {
+			audit_msg(LOG_ERR,
+			  "Error: uring op auditing being added to user list");
+			return -1;
+		} else if (((add & (AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_FS || (del &
+				(AUDIT_FILTER_MASK|AUDIT_FILTER_UNSET)) =3D=3D
+				AUDIT_FILTER_FS)) {
+			audit_msg(LOG_ERR,
+			  "Error: uring op auditing being added to filesystem list");
+			return -1;
+		} else if (exclude) {
+			audit_msg(LOG_ERR,
+		    "Error: uring op auditing cannot be put on exclude list");
+			return -1;
+		} else if (((add | del) & AUDIT_FILTER_MASK) =3D=3D AUDIT_FILTER_EXIT) {
+			audit_msg(LOG_ERR,=20
+		    "Error: uringop auditing cannot be put on syscall list");
+			return -1;
+		}
+		rc =3D parse_uringop(optarg);
+		switch (rc)
+		{
+			case 0:
+				_audit_uringopadded =3D 1;
+				break;
+			case -1:
+				audit_msg(LOG_ERR, "Uring op name unknown: %s",
+							optarg);
+				retval =3D -1;
+				break;
+			case -3: // Error reported - do nothing here
+				retval =3D -1;
+				break;
+		}
+		break;
         case 'F':
 		if (add !=3D AUDIT_FILTER_UNSET)
 			flags =3D add & AUDIT_FILTER_MASK;
 		else if (del !=3D AUDIT_FILTER_UNSET)
 			flags =3D del & AUDIT_FILTER_MASK;
-		// if the field is arch & there is a -t option...we=20
+		// if the field is arch & there is a -t option...we
 		// can allow it
-		else if ((optind >=3D count) || (strstr(optarg, "arch=3D") =3D=3D NULL)
+		else if ((optind >=3D count) || (strstr(optarg, "arch=3D") =3D=3D NULL &=
& _audit_uringopadded !=3D 1)
 				 || (strcmp(vars[optind], "-t") !=3D 0)) {
 			audit_msg(LOG_ERR, "List must be given before field");
 			retval =3D -1;
@@ -989,12 +1078,12 @@ static int setopt(int count, int lineno, char *vars[=
])
 		}
 		break;
 	case 'k':
-		if (!(_audit_syscalladded || _audit_permadded ||
-		      _audit_exeadded ||
+		if (!(_audit_syscalladded || _audit_uringopadded ||
+		      _audit_permadded || _audit_exeadded ||
 		      _audit_filterfsadded) ||
 		    (add=3D=3DAUDIT_FILTER_UNSET && del=3D=3DAUDIT_FILTER_UNSET)) {
 			audit_msg(LOG_ERR,
-		    "key option needs a watch or syscall given prior to it");
+		    "key option needs a watch, syscall or uring op given prior to it");
 			retval =3D -1;
 			break;
 		} else if (!optarg) {
@@ -1031,7 +1120,7 @@ process_keys:
 			retval =3D audit_setup_perms(rule_new, optarg);
 		break;
         case 'q':
-		if (_audit_syscalladded) {
+		if (_audit_syscalladded || _audit_uringopadded) {
 			audit_msg(LOG_ERR,=20
 			   "Syscall auditing requested for make equivalent");
 			retval =3D -1;
@@ -1466,7 +1555,7 @@ int main(int argc, char *argv[])
 static int handle_request(int status)
 {
 	if (status =3D=3D 0) {
-		if (_audit_syscalladded) {
+		if (_audit_syscalladded || _audit_uringopadded) {
 			audit_msg(LOG_ERR, "Error - no list specified");
 			return -1;
 		}
@@ -1478,7 +1567,7 @@ static int handle_request(int status)
 		if (add !=3D AUDIT_FILTER_UNSET) {
 			// if !task add syscall any if not specified
 			if ((add & AUDIT_FILTER_MASK) !=3D AUDIT_FILTER_TASK &&=20
-					_audit_syscalladded !=3D 1) {
+					(_audit_syscalladded !=3D 1 && _audit_uringopadded !=3D 1)) {
 					audit_rule_syscallbyname_data(
 							rule_new, "all");
 			}
@@ -1502,7 +1591,7 @@ static int handle_request(int status)
 		}
 		else if (del !=3D AUDIT_FILTER_UNSET) {
 			if ((del & AUDIT_FILTER_MASK) !=3D AUDIT_FILTER_TASK &&=20
-					_audit_syscalladded !=3D 1) {
+					(_audit_syscalladded !=3D 1 && _audit_uringopadded !=3D 1)) {
 					audit_rule_syscallbyname_data(
 							rule_new, "all");
 			}
--=20
2.27.0

